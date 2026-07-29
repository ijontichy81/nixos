{ config, lib, pkgs, ... }:

let
  koboldcpp-fixed = pkgs.koboldcpp.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      ln -sfn "$out/bin" "$out/bin/embd_res"
    '';
  });

  status-script = pkgs.writeShellScript "koboldcpp-wrapper" ''
    set +o pipefail
    shopt -s lastpipe

    model=""
    next_is_model=0
    for arg in "$@"; do
      if [ "$next_is_model" = 1 ]; then
        model="$arg"
        next_is_model=0
      fi
      [ "$arg" = "--sdmodel" ] && next_is_model=1
    done

    echo "=== KoboldCPP ==="
    echo "Model: $(basename "$model")"

    logfile=$(mktemp /tmp/kcpp-log.XXXXXX)
    trap 'rm -f "$logfile"' EXIT

    (${koboldcpp-fixed}/bin/koboldcpp "$@" 2>&1; echo $? > "$logfile.exit") \
      | tee "$logfile" &
    kcpid=$!

    vae_status="unknown"
    vulkan_status="unknown"

    while kill -0 "$kcpid" 2>/dev/null; do
      if ! grep -q "Load Image Model OK:" "$logfile" 2>/dev/null; then
        sleep 1
        continue
      fi

      args_line=$(grep "^Namespace(" "$logfile" 2>/dev/null | head -1 || true)
      if [ -n "$args_line" ]; then
        sdvae=$(echo "$args_line" | sed -n "s/.*sdvae='\([^']*\)'.*/\1/p" 2>/dev/null || true)
        if [ -z "$sdvae" ]; then
          sdvae=$(echo "$args_line" | sed -n "s/.*sdvae=None.*/None/p" 2>/dev/null || true)
        fi
        if [ -n "$sdvae" ]; then
          vae_status="$sdvae"
        else
          vae_status="baked-in (no external VAE)"
        fi
        case "$args_line" in
          *usevulkan=True*) vulkan_status="loaded" ;;
          *usevulkan=False*) vulkan_status="not used" ;;
        esac
      fi

      if grep -qi "taesd" "$logfile" 2>/dev/null; then
        vae_status="TAESD (--sdvaeauto)"
      fi
      break
    done

    echo "VAE:   $vae_status"
    echo "Backend: $vulkan_status"
    echo "================="

    wait "$kcpid"
    read -r ec < "$logfile.exit" 2>/dev/null || ec=1
    exit "$ec"
  '';
in
{
  environment.systemPackages = [ koboldcpp-fixed ];

  networking.firewall.allowedTCPPorts = [ 5001 ];

  systemd.services.koboldcpp = {
    description = "KoboldCPP AI server with Vulkan GPU support";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = lib.mkForce [ ];

    serviceConfig = {
      Type = "exec";
      User = "marco";
      Group = "vip";
      ExecStart = "${status-script} --sdmodel /home/marco/models/sd/milkyDreams_v40.safetensors --usevulkan --sdclipgpu --sdflashattention --sdoffloadcpu --sdconvdirect vaeonly --sdtiledvae 768 --sdlora /home/marco/models/sd/loras/ --host 0.0.0.0 --port 5001 --debugmode --nomodel";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

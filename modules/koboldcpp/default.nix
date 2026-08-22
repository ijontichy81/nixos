{ config, lib, pkgs, ... }:

let
  koboldcpp-fixed = pkgs.koboldcpp.overrideAttrs (old: {
    version = "1.119";
    src = pkgs.fetchFromGitHub {
      owner = "LostRuins";
      repo = "koboldcpp";
      tag = "v1.119";
      hash = "sha256-WJVbzh4BGLiQdd/rzqSe2Q9PGqMpsqmQNQf33INJkd8=";
    };
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

  commonFlags = "--usevulkan --sdclipgpu --sdflashattention --sdoffloadcpu --sdconvdirect vaeonly --sdtiledvae 1024 --sdvramlimit 5500 --sdlora /home/marco/models/sd/loras/ --sdthreads 6 --sdupscaler /home/marco/models/sd/remacri.safetensors --sdclampedsoft 2048 --debugmode --nomodel";

  mkKoboldService = name: svcName: model: port: {
    description = "KoboldCPP AI server with Vulkan GPU support (${name})";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" "${svcName}-sleepguard.service" ];
    wantedBy = lib.mkForce [ ];

    serviceConfig = {
      Type = "exec";
      User = "marco";
      Group = "vip";
      ExecStart = "${status-script} --sdmodel ${model} ${commonFlags} --host 0.0.0.0 --port ${toString port}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Blocks suspend/hibernate for as long as the matching koboldcpp service runs
  mkSleepGuard = svcName: {
    "${svcName}-sleepguard" = {
      description = "Inhibit sleep while ${svcName} is serving requests";
      partOf = [ "${svcName}.service" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=sleep --mode=block --who=${svcName} --why=\"${svcName} is generating\" ${pkgs.coreutils}/bin/sleep infinity";
      };
    };
  };

  # Manual CLI launches also block suspend while running
  koboldcpp-inhibited = pkgs.writeShellScriptBin "koboldcpp" ''
    exec ${pkgs.systemd}/bin/systemd-inhibit \
      --what=sleep --mode=block --who=koboldcpp-cli \
      --why="manual koboldcpp session" \
      ${koboldcpp-fixed}/bin/koboldcpp "$@"
  '';
in
{
  environment.systemPackages = [
    koboldcpp-fixed
    (lib.hiPrio koboldcpp-inhibited)
  ];

  networking.firewall.allowedTCPPorts = [ 5001 5002 ];

  systemd.services =
    {
      koboldcpp = mkKoboldService "lustify" "koboldcpp" "/home/marco/models/sd/gemCollection_opal.safetensors" 5001;
      koboldcpp-gem = mkKoboldService "gem" "koboldcpp-gem" "/home/marco/models/sd/gemCollection_proteus.safetensors" 5002;
    }
    // mkSleepGuard "koboldcpp"
    // mkSleepGuard "koboldcpp-gem";
}

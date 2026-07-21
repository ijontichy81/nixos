{ pkgs, ... }:
let
  backupScript = pkgs.writeShellScriptBin "spotify-backup" ''
    set -euo pipefail

    BACKUP_DIR="''${HOME}/spotify-backups"
    SPOTIFYCLI="${pkgs.spotifycli}/bin/spotifycli"
    mkdir -p "$BACKUP_DIR"

    # get all playlists (skip header lines)
    playlists=$("$SPOTIFYCLI" playlists 2>/dev/null | tail -n +4 || true)

    if [ -z "$playlists" ]; then
      echo "No playlists found or auth failed."
      exit 1
    fi

    echo "$playlists" | while IFS='|' read -r _ name _; do
      name=$(echo "$name" | xargs)
      [ -z "$name" ] && continue
      safe_name=$(echo "$name" | tr '/' '_' | tr -dc '[:alnum:]._- ')
      safe_name="''${safe_name%"''${safe_name##*[! ]}"}"
      "$SPOTIFYCLI" list --p "$name" > "$BACKUP_DIR/''${safe_name}.txt" 2>/dev/null || true
    done

    # save full playlist list
    "$SPOTIFYCLI" playlists > "$BACKUP_DIR/_all_playlists.txt" 2>/dev/null || true

    echo "Backed up to $BACKUP_DIR"
  '';
in {
  home.packages = with pkgs; [
    spotifycli
    backupScript
  ];

  systemd.user.services.spotify-backup = {
    Unit = {
      Description = "Backup Spotify playlists";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${backupScript}/bin/spotify-backup";
    };
  };

  systemd.user.timers.spotify-backup = {
    Unit = {
      Description = "Daily Spotify playlist backup";
    };
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

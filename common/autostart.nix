{ config, pkgs, ... }:

{
  systemd.user.services = {
    webcord = {
      description = "WebCord Discord client";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.flatpak}/bin/flatpak run --branch=stable --arch=x86_64 --env=NODE_OPTIONS=--max-old-space-size=4096 --env=sgx.enclave_size=4G --command=run.sh io.github.spacingbat3.webcord -m";
        Restart = "on-failure";
      };
    };

    easyeffects = {
      description = "Easy Effects Service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
        Restart = "on-failure";
      };
    };

    geary = {
      description = "Geary email client";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.gnome.geary}/bin/geary --gapplication-service";
        Restart = "on-failure";
      };
    };

    pika-backup = {
      description = "Pika Backup";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.flatpak}/bin/flatpak run --command=pika-backup-monitor org.gnome.World.PikaBackup";
        Restart = "on-failure";
      };
    };

    steam-minimized = {
      description = "Steam (Minimized)";
      wantedBy = [ "default.target" "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = "${pkgs.steam}/bin/steam -silent";
        Restart = "on-failure";
      };
    };

    whatsapp-for-linux = {
      description = "WhatsApp for Linux";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.whatsapp-for-linux}/bin/whatsapp-for-linux";
        Restart = "on-failure";
      };
    };
  };
}

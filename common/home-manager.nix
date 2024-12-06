{ config, pkgs, inputs, home-manager, lib, ... }:
{
  # Import the Home Manager NixOS module
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # NixOS system-wide home-manager configuration
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # Home Manager configuration for the user 'tim'
  home-manager.users.tim = {
    # Specify the Home Manager state version
    home.stateVersion = "24.11";

    imports = [ 
      ./dconf.nix 
      ./qemu.nix
    ];

    # Sops Home Configuration
    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.sshKeyPaths = [ "/home/tim/.ssh/id_ed25519y" ];

    # Git configuration
    programs.git = {
      enable = true;
      userName = "timlisemer";
      userEmail = "timlisemer@gmail.com";

      # Set the default branch name using the attribute set format
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = [ "/etc/nixos" "/tmp/NixOs" ];
        pull.rebase = "false";
      };
    };

    # Firefox Theme
    home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
    home.file.".mozilla/firefox/default/chrome/userChrome.css".text = ''
      @import "firefox-gnome-theme/userChrome.css";
      @import "firefox-gnome-theme/theme/colors/dark.css";
    '';

    home.activation = {
      firefoxThemeActivation = ''
        # Ensure userContent.css exists and is non-empty
        
        mkdir -p $HOME/.mozilla/firefox/default/chrome/
        [[ -s "$HOME/.mozilla/firefox/default/chrome/userContent.css" ]] || echo >> "$HOME/.mozilla/firefox/default/chrome/userContent.css"

        # Insert @import statement at the beginning of userContent.css before any @namespace
        sed -i '1s/^/@import "firefox-gnome-theme\/userContent.css";\n/' "$HOME/.mozilla/firefox/default/chrome/userContent.css"
      '';
    };

    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "signon.rememberSignons" = false;

            # For Firefox GNOME theme:
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.drawInTitlebar" = true;
            "svg.context-properties.content.enabled" = true;
            "widget.gtk.rounded-bottom-corners.enabled" = true;
          };
        };
      };
    };


    programs.atuin = {
      enable = true;
      # https://github.com/nix-community/home-manager/issues/5734
    };

    # GTK theme configuration
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };


    home.packages = with pkgs; [
      atuin
      sops
    ];
  
    # Files and folders to be symlinked into home
    home.file = {

      ".config/ags".source = builtins.toPath ../files/ags;
      ".config/hypr".source = builtins.toPath ../files/hypr;
      ".config/starship.toml".source = builtins.toPath ../files/starship.toml;
      ".config/wireplumber".source = builtins.toPath ../files/wireplumber;
      "Pictures/Wallpapers".source = builtins.toPath ../files/Wallpapers;
      ".bash_profile".source = builtins.toPath ../files/bash_profile;
      ".bashrc".source = builtins.toPath ../files/bashrc;
      ".stignore".source = builtins.toPath ../files/stignore;
      ".vimrc".source = builtins.toPath ../files/vimrc;

      # Arduino
      ".arduinoIDE/ia.txt" = { text = '' ia! ''; executable = false; };
      ".arduinoIDE/arduino-cli.yaml".source = builtins.toPath ../files/arduino/arduino-cli.yaml;

      # EasyEffects
      ".config/easyeffects/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/easyeffects/autoload/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/easyeffects/autoload/input/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/easyeffects/input/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/easyeffects/autoload/input/alsa_input.usb-R__DE_R__DE_NT-USB__02447C32-00.mono-fallback:.json".source = builtins.toPath ../files/easyeffects/autoload/input;
      ".config/easyeffects/input/Discord.json".source = builtins.toPath ../files/easyeffects/input;

      # OpenRGB
      ".config/OpenRGB/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/OpenRGB/plugins/settings".source = ../files/OpenRGB/plugins/settings;
      ".config/OpenRGB/Off.orp".source = ../files/OpenRGB/Off.orp;
      ".config/OpenRGB/On.orp".source = ../files/OpenRGB/On.orp;
      ".config/OpenRGB/OpenRGB.json".source = ../files/OpenRGB/OpenRGB.json;
      ".config/OpenRGB/sizes.ors".source = ../files/OpenRGB/sizes.ors;

      # nvim
      ".config/nvim/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/nvim/after".source = "${inputs.tim-nvim}/after";
      ".config/nvim/lua".source = "${inputs.tim-nvim}/lua";
      ".config/nvim/init.lua".source = "${inputs.tim-nvim}/init.lua";

      # blesh
      ".local/share/blesh".source = inputs.blesh;

      # WhatsApp
      ".config/whatsapp-for-linux/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/whatsapp-for-linux/settings.conf".source = builtins.toPath ../files/whatsapp-for-linux/settings.conf;

      # Vscode
      ".config/Code/User/ia.txt" = { text = '' ia! ''; executable = false; };
      ".config/Code/User/settings.json".source = builtins.toPath ../files/vscode/settings.json;
    };

    # Steam adwaita theme
    systemd.user.services.installAdwaitaTheme = {
      Unit = {
        Description = "Install Adwaita Theme for Steam";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "install-adwaita-theme" ''
          if [ ! -d $HOME/.config/steam-adwaita-theme ]; then
            ${pkgs.git}/bin/git clone https://github.com/tkashkin/Adwaita-for-Steam $HOME/.config/steam-adwaita-theme
          else
            cd $HOME/.config/steam-adwaita-theme
            ${pkgs.git}/bin/git reset --hard
            ${pkgs.git}/bin/git pull
          fi
          cd $HOME/.config/steam-adwaita-theme
          ${pkgs.python3}/bin/python3 install.py -c adwaita -e library/hide_whats_new
        ''}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    xdg.desktopEntries = {
      discord = {
        name = "Discord";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        exec = "discordcanary --enable-features=UseOzonePlatform --ozone-platform=wayland";
        terminal = false;
        icon = "discord";
        categories = [ "Network" "InstantMessaging" ];
        mimeType = [ "x-scheme-handler/discord" ];
      };
    };
  };
}

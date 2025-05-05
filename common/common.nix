{ config, pkgs, inputs, ... }: {

  # Enviroment Variables
  environment.variables = {
    RUST_SRC_PATH                  = "${pkgs.rustPlatform.rustLibSrc}";
    NVD_BACKEND                    = "direct";
    MOZ_DISABLE_RDD_SANDBOX        = "1";
    LIBVA_DRIVER_NAME              = "nvidia";
    MUTTER_DEBUG_KMS_THREAD_TYPE   = "user";
    NODE_OPTIONS                   = "--max-old-space-size=4096";
    SGX_ENCLAVE_SIZE               = "4G";
    RUST_MIN_STACK                 = "268435456";
    QT_QPA_PLATFORM                = "wayland";
    NIXPKGS_ALLOW_UNFREE           = "1";  # duplication with nixpkgs.config.allowUnfree
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";  # Tauri Apps couldn’t run on NixOS NVIDIA

    # Ensure coreutils are in $PATH
    # PATH = "${pkgs.lib.makeBinPath [ pkgs.coreutils ]}:$HOME/.bin";
  };

  # Enable experimental nix-command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree and broken packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT    = "de_DE.UTF-8";
    LC_MONETARY       = "de_DE.UTF-8";
    LC_NAME           = "de_DE.UTF-8";
    LC_NUMERIC        = "de_DE.UTF-8";
    LC_PAPER          = "de_DE.UTF-8";
    LC_TELEPHONE      = "de_DE.UTF-8";
    LC_TIME           = "de_DE.UTF-8";
  };

  # NixOS garbage collection
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 7d";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Some programs need SUID wrappers or run in user sessions
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable                   = true;
    settings.PermitRootLogin = "yes";
  };

  # VSCode Server
  services.vscode-server.enable = true;

  # Fix shebangs in scripts
  services.envfs.enable = true;

  # Syncthing (disabled by default)
  services.syncthing = {
    enable          = false;
    user            = "tim";
    dataDir         = "/home/tim";
    configDir       = "/home/tim/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "tim-server" = {
          id                = "ZKX6K7U-XPIMO7N-QM7KBU7-5OPVX7S-3E4UDW7-YKQBR2P-ZU4DC3F-ZYC34A3";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Home" = {
          path      = "/home/tim";
          devices   = [ "tim-server" ];
          addresses = [ "tcp://10.0.0.2:22000" ];
        };
      };
    };
  };

  # Open ports in the firewall
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable entirely:
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It’s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing it read the docs (e.g. man configuration.nix or
  # https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";  # Did you read the comment?
}
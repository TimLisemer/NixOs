{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    nautilus-open-any-terminal
    tree
    syncthing
    vaapiVdpau
    comfortaa
    bat
    cliphist
    dejavu_fonts
    dracut
    elfutils
    fastfetch
    fd
    ffmpeg
    fzf
    gamemode
    just
    unzip
    justbuild
    sockdump
    qemu
    ripgrep
    trash-cli
    vdpauinfo
    wl-clipboard
    xorg.xeyes
    zoxide
    starship
    nerdfonts
    switcheroo-control
    dconf2nix
    dive
    podman-tui
    docker-compose
    podman-compose
    i2c-tools
    liquidctl
  ];
}

{ config, pkgs, ... }:

let
  vscodeExtensions = pkgs.vscode-extensions;
in
{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscodeExtensions; [
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ];
    })

    qtcreator
    jetbrains.clion
    jetbrains.rust-rover
    jetbrains.rider
    jetbrains.idea-community
    jetbrains.pycharm-community
    conda
    cmake
    composefs
    dbus
    flatpak
    libgcc
    go
    gtk3
    gtk4
    julia
    libadwaita
    libinput
    lld
    libllvm
    luarocks
    meson
    nodejs
    linux-pam
    perl
    php
    pixman
    podman
    podman-compose
    protobuf
    ruby
    typescript   
  ];
}

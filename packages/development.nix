{
  config,
  pkgs,
  inputs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    config = {allowUnfree = true;};
    inherit (pkgs) system;
  };
  oldvscode = import inputs.nixpkgs-oldvscode {
    config = {allowUnfree = true;};
    inherit (pkgs) system;
  };
  vscodeExtensions = pkgs.vscode-extensions;
in {
  environment.systemPackages = with pkgs; [
    (oldvscode.vscode-with-extensions.override {
      vscodeExtensions = with vscodeExtensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        github.copilot
        unstable.vscode-extensions.github.copilot-chat
        unstable.vscode-extensions.egirlcatnip.adwaita-github-theme
        dbaeumer.vscode-eslint
        bbenoist.nix
        tauri-apps.tauri-vscode
        rust-lang.rust-analyzer
        njpwerner.autodocstring
        svelte.svelte-vscode
        tamasfe.even-better-toml
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        foxundermoon.shell-format
        bradlc.vscode-tailwindcss
        kamadorueda.alejandra
      ];
    })

    arduino-ide
    qtcreator
    libsForQt5.qt5.qtbase
    kdePackages.qtbase
    jetbrains.clion
    jetbrains.rider
    jetbrains.rust-rover
    jetbrains.idea-community
    jetbrains.pycharm-community
    conda
    cmake
    composefs
    dbus
    dos2unix
    libgcc
    jdk
    python3
    python3Packages.pip
    phpPackages.composer
    go
    gtk3
    gtk4
    julia
    libadwaita
    libinput
    lld
    libllvm
    luarocks
    lua
    meson
    nodejs
    linux-pam
    openssl
    perl
    php
    pixman
    protobuf
    ruby
    typescript
    gnumake
    neovim
    gcc
    clang
    zig
    fzf
    black
    python3Packages.black
    pylint
    python3Packages.pylint
    isort
    python3Packages.isort
    stylua
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.vscode-langservers-extracted
    nodePackages.svelte-language-server
    tailwindcss-language-server
    lua-language-server
    nodePackages.graphql-language-service-cli
    emmet-ls
    vimPlugins.nvim-treesitter-parsers.prisma
    tree-sitter-grammars.tree-sitter-prisma
    vimPlugins.vim-prisma
    vimPlugins.nvim-treesitter-parsers.regex
    vimPlugins.nvim-treesitter-parsers.bash
    vimPlugins.nvim-treesitter-parsers.markdown
    vimPlugins.nvim-treesitter-parsers.markdown_inline
    vimPlugins.mini-nvim
    pyright
    rust-analyzer
    prettierd
    eslint_d
    pkg-config
    gobject-introspection
    cargo
    cargo-tauri
    nodejs
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    pango
    webkitgtk_4_1
    openssl
    zlib
  ];
}

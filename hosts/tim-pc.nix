{ config, pkgs, ... }:

{

  # Import the common configuration shared across all machines
  imports = [
    ../common/common.nix
    ./tim-pc-hardware-configuration.nix
  ];

  # Machine specific configurations

  networking.hostName = "tim-pc";  
}
{ config, lib, pkgs, ... }:

{
  services.mysql = {
    enable = true; 
    extraOptions = ''
      max_allowed_packet = 64M
    '';
    package = pkgs.mysql;
  };

  # Elasticsearch version 6.8
  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch;
  };

  services.redis = {
    enable = true;
  };
}

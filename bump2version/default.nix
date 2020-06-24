{ config, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

let
  bump2version = pkgs.python37Packages.callPackage ./bump2version.nix { };
in {
  home.packages = [
    bump2version
  ];
}

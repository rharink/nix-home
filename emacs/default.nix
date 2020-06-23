
{ config, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

let
  custom-emacs = pkgs.unstable.emacsWithPackages (with pkgs.unstable.emacsPackagesNg; [
    vterm
  ]);

in {
  home.packages = [
    custom-emacs
  ];

  home.file = {
    ".doom.d/init.el".source = ./doom.d/init.el;
    ".doom.d/config.org".source = ./doom.d/config.org;

    # TODO: I still configure doom emacs by hand
    #".emacs.d" = {
    #  source = fetchFromGitHub {
    #    owner = "hlissner";
    #    repo = "doom-emacs";
    #    rev = "99eea1d3e25d8bf6034ff31d231e4ecfc3dc628c";
    #    sha256 = "0km1q1dgvixvx1si4plzyn9vnk9kidrgc6p07xx956i85mg8ami9";
    #  };
    #  recursive = true;
    #};

  };
}

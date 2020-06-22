{ config, lib, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "robert";
  home.homeDirectory = "/home/robert";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  imports = [
    ./fish
    ./htop.nix
    ./tmux.nix
  ];

  home.packages = [
    # Basics
    pkgs.unzip
    pkgs.wget
    pkgs.glibcLocales
    pkgs.gnupg
    pkgs.ripgrep
    pkgs.libvterm 
    pkgs.libtool
    pkgs.cmake
    pkgs.editorconfig-checker
    pkgs.editorconfig-core-c
    pkgs.direnv

    # Rust cli tools
    pkgs.exa
    pkgs.bat
    pkgs.tokei
    pkgs.xsv
    pkgs.fd

    # Files
    pkgs.zstd               # Compression
    pkgs.restic             # Backups
    pkgs.brig
    pkgs.ipfs

    # Editors
    # TODO: I still configure doom emacs by hand
    pkgs.emacs
    
    # Shell
    pkgs.termite
    pkgs.tmux

    # Overview
    pkgs.htop
    pkgs.wtf
    pkgs.neofetch
    pkgs.lazygit

    # Pen/testing
    pkgs.jmeter

    # Media
    pkgs.vlc
    pkgs.rtv # Reddit

    # Programs
    # pkgs.vscode
    # pkgs.sublime3
    # pkgs.sublime-merge
    # pkgs.keybase
    # pkgs.keybase-gui
    hledger-ui
    hledger-web

    # Writing
    pkgs.pandoc
    pkgs.texlive.combined.scheme-tetex
    pkgs.plantuml

    # Other
    pkgs.jq
    pkgs.mosh
    pkgs.xclip
  ];

  programs.git.delta.enable = true;

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Robert den Harink";
    userEmail = "robert@robhar.com";
    signing = {
      key = "F96DC84AFA46DC19";
      signByDefault = true;
    };
    extraConfig = {
      core = {
        excludesFile = "~/.config/git/gitignore";
        editor = "vim";
        autocrlf = "input";
        safecrlf = "warn";
      };
      inlcude = {
        path = "~/.gitconfig.local";
      };
      github = {
        user = "rharink";
      };
      pull = {
        rebase = true;
      };
      commit = {
        template = "~/.config/git/gitmessage";
      };
      apply = {
        whitespace = "fix";
      };
      diff = {
        tool = "vimdiff";
      };
      merge = {
        tool = "vimdiff";
      };
      alias = {
        # Commit count
        count = "!git shortlog -sn";

        # force-with-lease option is far more polite.
        # it checks that your local copy of the ref that you’re overwriting is
        # up-to-date before overwriting it. This indicates that you’ve at least
        # fetched the changes you’re about to stomp.
        please = "push --force-with-lease";

        # Ever commit and then immediately realize you’d forgotten to stage a file?
        # git commend quietly tacks any staged files onto the last commit you
        # created, re-using your existing commit message. So as long as you haven’t
        # pushed yet, no-one will be the wiser.
        commend = "commit --amend --no-edit";

        # Prune local tags that do not exist on remote
        prunetags = "!git tag -l | xargs git tag -d && git fetch -t";
      };
    };
  };

  # TODO: Implement customRC, and figure out why plugins are not working
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    configure = {
      #customRC = builtins.readFile ./neovim/init.vim;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ale
          auto-pairs
          nerdcommenter
          nerdtree
          surround
          easymotion
        ];
      };
    };
  };

  programs.command-not-found.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.lorri.enable = true;

  home.file = {
    ".config/git/gitmessage".source = ./git/gitmessage;
    ".config/git/gitignore".source = ./git/gitignore;
    # TODO: use programs.alacritty, but this giver errors on fedora32
    ".config/alacritty/alacritty.yml".source = ./alacritty/alacritty.yml;
  };
}

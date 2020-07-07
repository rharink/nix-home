{ config, pkgs, ... }:

let dquot = "''";
in {
  programs.fish.enable = true;

  home.file = {
    # greeting
    ".config/fish/functions/fish_greeting.fish".text = ''
      function fish_greeting;end
    '';

    # prompt
    ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;

    # global fish config
    ".config/fish/conf.d/robhar.fish".text = ''
      alias edit "emacsclient -cna ${dquot}"
      alias e "edit"

      alias tm "tmux -2 new -A -s base"
      alias vd "vimdiff"
      alias vim "nvim"

      # Screen/monitor setup aliases
      #alias screen-dual "xrandr --setprovideroutputsource 1 0; xrandr --output DVI-I-1-1 --auto --above eDP1"

      alias cat "bat"
      alias ls "exa"

      # Git aliasses
      alias gs "git status -sb"
      alias gd "git diff"
      alias gc "git commit"
      alias gca "git commit -a"
      alias gl "git pull --prune"
      alias grb "git rebase -i @{u}"

      # Darcs aliasses
      alias dw "darcs whatsnew"
      alias ds "darcs whatsnew -s"
      alias ddiff "darcs diff"
      alias dl "darcs log"
      alias da "darcs add"
      alias dr "darcs record"
      set -U DARCS_EDITOR vim

      # Exports
      #set -x LANG "en_US.UTF-8"
      #set -x LC_ALL "en_US.UTF-8"
      #set -x MANPAGER "less -X"
      #set -x GIT_COMPLETION_CHECKOUT_NO_GUESS "1"
      #set -x MAILCHECK "0"


      # Source local stuff.
      source ~/.localrc

      # Use nix
      #fenv "source ~/.nix-profile/etc/profile.d/nix.sh"
      eval (direnv hook fish)

    '';

    ".config/fish/conf.d/colors.fish".text = ''
      switch $TERM
        case '*xte*'
          set -gx TERM xterm-256color
        case '*scree*'
          set -gx TERM screen-256color
        case '*rxvt*'
          set -gx TERM rxvt-unicode-256color
      end

      # Base16 Shell
      if status --is-interactive
          set BASE16_SHELL "$HOME/.config/base16-shell/"
          source "$BASE16_SHELL/profile_helper.fish"
      end
    '';

    ".config/fish/conf.d/gpg.fish".text = ''
      gpg-agent --daemon --enable-ssh-support > /dev/null 2>&1
      set -x GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    '';

    ".config/fish/functions/fenv.fish".source = ./functions/fenv.fish;
    ".config/fish/functions/fenv.apply.fish".source = ./functions/fenv.apply.fish;
    ".config/fish/functions/fenv.main.fish".source = ./functions/fenv.main.fish;
    ".config/fish/functions/fenv.parse.after.fish".source = ./functions/fenv.parse.after.fish;
    ".config/fish/functions/fenv.parse.before.fish".source = ./functions/fenv.parse.before.fish;
    ".config/fish/functions/fenv.parse.diff.fish".source = ./functions/fenv.parse.diff.fish;
    ".config/fish/functions/fenv.parse.divider.fish".source = ./functions/fenv.parse.divider.fish;
    ".config/fish/functions/vault_ssh_sign.fish".source = ./functions/vault_ssh_sign.fish;
  };

  programs.fish.shellAliases = {
    pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
    pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
  };
}

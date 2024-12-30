{ config, pkgs, ... }:

{
  home.username = "purple-mountain";
  home.homeDirectory = "/home/purple-mountain";

  home.sessionVariables = {
    IBUS_ENABLE_SYNC_MODE = "1";
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    podman
    distrobox
    jetbrains.idea-ultimate
    obsidian
	  firefox-devedition
    google-chrome
	  xfce.thunar
	  font-manager
	  anki
	  telegram-desktop
	  flameshot
	  p7zip
    zip
    xarchiver
	  gthumb
    qbittorrent
	  zoxide
    vlc
	  zoom-us
    shellcheck
    discord
    appimage-run
    spotify
    postman
    wireshark
    feh
    scrot
    i3lock
    fastfetch
  ];

  home.file = {
    ".config" = {
      source = ../../dotfiles;
      recursive = true;
    };
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      nixswitch = "sudo nixos-rebuild switch --flake ~/nixos/#default";
      nixtest = "sudo nixos-rebuild test --flake ~/nixos/#default";
      vim="nvim";
      cfg="sudo -sE ";
      dc="docker-compose";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
    ];
    oh-my-zsh = {
      	enable = true;
      	# plugins = [ "" "" ];
    	theme = "robbyrussell";
    };
    initExtra = ''
    	autoload -Uz compinit promptinit 
    	eval "$(zoxide init zsh)"
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      export PATH=$HOME/.local/bin:$PATH
      export ANDROID_HOME=$HOME/Android/Sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
    '';
  };
}

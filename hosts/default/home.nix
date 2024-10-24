{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "purple-mountain";
  home.homeDirectory = "/home/purple-mountain";

  home.sessionVariables = {
    IBUS_ENABLE_SYNC_MODE = "1";
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    teams-for-linux
    vscode
    wireshark
    feh
    scrot
    i3lock
    # nodePackages.volar
    # nodePackages.typescript-language-server
    # rust-analyzer
    # lua-language-server
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  ".config" = {
		source = ../../dotfiles;
		recursive = true;
	};
	
	#".zshrc".text = ''
	#     autoload -Uz compinit promptinit
	#     compinit
	#     # promptinit
	#'';
        #tmux = {
        #    source = config.lib.file.mkOutOfStoreSymlink "../../dotfiles/tmux/tmux.conf";
        #    target = "./.tmux.conf";
        #};

        #i3 = {
        #    source = config.lib.file.mkOutOfStoreSymlink "../../dotfiles/i3";
        #    target = "./.config/i3";
        #};

	#".config/i3" = {
        #    source = config.lib.file.mkOutOfStoreSymlink "../../dotfiles/i3";
	#};
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/purple-mountain/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
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

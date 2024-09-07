# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ../../purple-mountain.nix		
    ];

# Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

#  sound.enable = true;
#  hardware.pulseaudio.enable = true;
#  hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];


  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

	hardware.nvidia.prime = {
  	offload = {
			enable = true;
			enableOffloadCmd = true;
		};
		# Make sure to use the correct Bus ID values for your system!
		nvidiaBusId = "PCI:1:0:0";
		intelBusId = "PCI:0:2:0";
	};


  main-user.enable = true;
  main-user.userName = "purple-mountain";

  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText"openssl.cnf"''
  openssl_conf = openssl_init
  [openssl_init]
  ssl_conf = ssl_sect
  [ssl_sect]
  system_default = system_default_sect
  [system_default_sect]
  Options = UnsafeLegacyRenegotiation
  [system_default_sect]
  CipherString = Default:@SECLEVEL=0
  ''
  ;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tashkent";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [mozc];

    # enabled = "fcitx5";
    # fcitx5.addons = with pkgs; [
    #   fcitx5-mozc
    #   fcitx5-gtk
    # ];
    # fcitx.engines = with pkgs.fcitx5-engines; [ mozc ];
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Configure keymap in X11
  services.xserver = {
  	enable = true;
  	autorun = false;
    xkb = {
      variant = "";
      options = "grp:alt_shift_toggle";
      layout = "us, ru";
    };
  	desktopManager = {
    	xterm.enable = false;
    };
    displayManager = {
      lightdm.enable = true;
    };
  	windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";

  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.purple-mountain = {
    isNormalUser = true;
    description = "main user";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "video" ];
    openssh.authorizedKeys.keys = ["AAAAC3NzaC1lZDI1NTE5AAAAIL+XgYBF7Ft8cXv3i+oDB7u77SyoKQx+GmKaOPr5jBgs"];
    packages = with pkgs; [
      htop
      libgcc
      lf
      xorg.xev
      picom
      polybar
      kitty
      dunst
      rofi
      alsa-utils
      alsa-lib
      alsa-plugins
      alsa-tools
      pulseaudio
      pavucontrol
      lshw
      lsof
      flatpak
      wpa_supplicant
      wpa_supplicant_gui
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };	  
    users = {
      "purple-mountain" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rar
    unrar
    mkvtoolnix
    ffmpeg
    libgcc
    stdenv.cc.cc.lib
    gnumake
    unzip
    ripgrep
    fd
    cmake

    nodejs_20
    corepack_20
    go
    zig
    python3
    yarn
    brightnessctl

    emacs
    neovim-unwrapped
    vim
    neofetch
    tmux
    git
    gh
    lunarvim
    xclip
    wineWowPackages.stable
    winetricks
    bottles-unwrapped
    lutris-unwrapped
    llama-cpp
    xorg.libxcb
    # mesa
    # vulkan-headers
    # vulkan-loader
    # vulkan-validation-layers
    # vulkan-tools
    docker-compose
  ];

  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono" "RobotoMono"]; })
    material-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ipafont
    kochi-substitute
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

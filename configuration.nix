# TODO move all flakes stuff to flake.nix
#  nixpkgs.overlays = [ inputs.nur.overlay ];
# pin nixpkgs in the system-wide flake registry
#nix.registry.nixpkgs.flake = inputs.nixpkgs;

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];

  services.sshd.enable = true;

  # TODO use distcc to distribute ALL builds across multiple machines ("build farm")
  services.distccd = {
    enable = true;
    allowedClients = [ "127.0.0.1" "192.168.1.0/24" ];
    openFirewall = true;
    zeroconf = true;
  };

  networking.hostName = "laptop1";



nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #"osu-lazer"
  #"flashplayer"
  #"vscode"
  "cnijfilter2" # canon printer: cnijfilter2-6.10
  "font-bh-lucidatypewriter-75dpi" # https://github.com/NixOS/nixpkgs/issues/99014
];

/*
  nixpkgs.config = {
    allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [
      #"flashplayer"
      #"vscode"
      "cnijfilter" # canon printer
    ]);
    firefox = {
      # constantly broken https://github.com/NixOS/nixpkgs/issues/55657
      #enableAdobeFlash = true;
    };
  };
*/


/* moved to flake.nix
  # flakes
  nix.package = pkgs.nixUnstable; # https://nixos.wiki/wiki/Flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
*/

/*
    keep-outputs = true
    keep-derivations = true
*/


# https://nixos.wiki/wiki/Distributed_build
# TODO distcc??
     nix.buildMachines = [
#/xx* laut
       {
         hostName = "laptop2";
         system = "x86_64-linux";
         maxJobs = 1;
         speedFactor = 2;
         supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
         mandatoryFeatures = [ ];
       }
#*/
/* fan error -> not booting
       {
         hostName = "laptop3";
         system = "x86_64-linux";
         maxJobs = 1;
         speedFactor = 2;
         supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
         mandatoryFeatures = [ ];
       }
*/
     ];

     nix.distributedBuilds = true;
        # optional, useful when the builder has a faster internet connection than yours
        #nix.extraOptions = ''
        #       builders-use-substitutes = true
        #'';

networking.extraHosts =
  ''
    192.168.1.191 laptop2
    192.168.1.179 laptop3
    127.0.0.1 laptop1 nixos-cache.laptop1
  '';


services.nix-serve = {
  enable = true;
  secretKeyFile = "/etc/nixos/nixos-cache/cache-priv-key.pem";
  # /etc/nixos/nixos-cache/cache-pub-key.pem
};


  fileSystems."/" =
  {
# TODO inherit device UUID from ,/hardware-configuration.nix
    #device = "/dev/disk/by-uuid/2e0a16b9-e026-4e69-8640-a2b2ce6d45bf"; # old SSD (240 GB)
    device = "/dev/disk/by-uuid/141c3965-7393-4459-ab03-ae90173d984f";
    fsType = "ext4";
    options = [ "rw" "data=ordered" "relatime" ];
  };





  programs.extra-container.enable = true; # nixos unstable





  # sudo sysctl net.core.rmem_max=4194304 net.core.wmem_max=1048576
  boot.kernel.sysctl."net.core.rmem_max" = 4194304; # transmission-daemon told me to = 10x more than 425984
  boot.kernel.sysctl."net.core.wmem_max" = 1048576;

  boot.supportedFilesystems = [ "ntfs" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only






#  networking.hostName = "laptop1"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # workaround for bug in firewall.nix
  ###########
networking.firewall.checkReversePath = false; # disable rpfilter for wg-quick

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

# locale
i18n.defaultLocale = "en_US.UTF-8";
i18n.extraLocaleSettings = {
  LC_MESSAGES = "en_US.UTF-8";
  LC_TIME = "de_DE.UTF-8";
  LC_CTYPE = "en_US.UTF-8";
};

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;





  #networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.enp0s25.useDHCP = false;
  #networking.interfaces.wls1.useDHCP = true; # wifi

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "de";
  console.font = "ter-i32b"; # large font
  #console.font = "Lat2-Terminus16";
  #console.packages = options.console.packages.default ++ [ pkgs.terminus_font ];
  #console.packages = console.packages.default ++ [ pkgs.terminus_font ];
  console.packages = [ pkgs.terminus_font ];
  console.earlySetup = true; # set font early in boot






  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.videoDrivers = [ "intel" ];
  #services.xserver.useGlamor = true; # TODO?

  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "user";


# === KDE SDDM ===

  services.xserver.displayManager.sddm.enable = true;

#  services.xserver.desktopManager.plasma5.enable = true; # broken since setting dpi to 144 ... login hangs with black screen

  services.xserver.desktopManager.xfce.enable = true;
#  services.xserver.desktopManager.cinnamon.enable = true; # would set qt5.style = "adwaita"

  # xfce would enable only qt4, see: env | grep QT_
#/* this breaks xfce desktop, cannot login
  qt5 = {
    enable = true;
    platformTheme = "gnome"; # fix: qt5.platformTheme is used but not defined
    style = "adwaita-dark"; # fix: qt5.style is used but not defined
  };
#*/

/* cannot set gtk theme system-wide?
gtk = {
  enable = true;
  font.name = "Victor Mono SemiBold 12";
  theme = {
    name = "SolArc-Dark";
    package = pkgs.solarc-gtk-theme;
  };
};
*/

/*
[Settings]
gtk-application-prefer-dark-theme=true
gtk-button-images=true
gtk-cursor-theme-name=breeze_cursors
gtk-cursor-theme-size=24
gtk-decoration-layout=icon:minimize,maximize,close
gtk-enable-animations=true
gtk-font-name=Noto Sans,  10
gtk-icon-theme-name=breeze-dark
gtk-menu-images=true
gtk-primary-button-warps-slider=false
gtk-toolbar-style=3

        gtk-icon-theme-name = "Adwaita-Dark"
        gtk-theme-name = "Adwaita-Dark"
*/
# https://unix.stackexchange.com/a/633088/295986
# https://wiki.archlinux.org/title/GTK#Configuration
# TODO https://www.reddit.com/r/NixOS/comments/nryv23/comment/hl9izs6/
# TODO https://nixos.wiki/wiki/GTK
# TODO https://github.com/NixOS/nixpkgs/issues/13537 # gtk icon cache
  environment.etc =
    let
      gtkSettings = ''
        gtk-application-prefer-dark-theme = "true"
        gtk-font-name = "DejaVu Sans 11"
      '';
    in
    {
      # no effect?
      "xdg/gtk-2.0/gtkrc".source = pkgs.writeText "gtk2-settings" gtkSettings;
      "xdg/gtk-3.0/settings.ini".source = pkgs.writeText "gtk3-settings" "[Settings]\n${gtkSettings}";
      "xdg/gtk-4.0/settings.ini".source = pkgs.writeText "gtk4-settings" "[Settings]\n${gtkSettings}";
    };

# no effect: fonts.fontconfig.dpi = 144; # blind people friendly :)


  # https://nixos.wiki/wiki/Tor
  services.tor.enable = true; # slow (but secure) socks proxy on port 9050: one circuit per destination address

  services.tor.client.enable = true; # fast (but risky) socks proxy on port 9063 for https: new circuit every 10 minutes
#  services.tor.client.enable = false; # needed for insecure services

#TODO  services.tor-insecure.enable = true; # slow (but secure) socks proxy on port 9050: one circuit per destination address

#TODO services.tor-insecure.relay.onionServices = {

/*
services.tor.relay.onionServices = {

"nix-locate" = {
      map = [{ port = 80; target = { port = 8080; }; }];
      version = 3;
      settings = {

#TODO default in tor-insecure
# FIXME this requires tor.client = false
# https://github.com/NixOS/nixpkgs/pull/48625
HiddenServiceSingleHopMode = true; # NON ANONYMOUS. use tor only for NAT punching
HiddenServiceNonAnonymousMode = true; # TODO verify. use extraConfig?
SocksPort = 0;

#HiddenServicePort = 80; # ?

};
    };
};
*/



  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint pkgs.gutenprintBin # canon etc
    #pkgs.hplip pkgs.hplipWithPlugin # hp
    #pkgs.samsungUnifiedLinuxDriver pkgs.splix # samsung
    pkgs.brlaser pkgs.brgenml1lpr # brother

# TODO verify
    pkgs.cnijfilter2 # filter program for canon pixma g5050, etc
    #nixpkgs-2021-04-19.cnijfilter2 # filter program for canon pixma g5050, etc

    #canon-cups-ufr2
  ];





  # increase size of /run/user/1000 (max = ram + swap = 8 + 16 = 24)
  # swap -> /etc/nixos/hardware-configuration.nix
  # https://unix.stackexchange.com/questions/597024/how-to-resize-the-run-directory
  services.logind.extraConfig = ''
    RuntimeDirectorySize=12G
    HandleLidSwitchDocked=ignore
  '';






  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker" # WARNING the docker group membership is effectively equivalent to being root! https://github.com/moby/moby/issues/9976
      "dialout" # arduino programming
      "cdrom" # burn cd/dvd
    ];
  };





# https://nixos.wiki/wiki/Fonts
fonts.fonts = with pkgs; [
  #corefonts # microsoft core fonts: impact, ...

/*
  open-sans
  noto-fonts
  #noto-fonts-cjk
  #noto-fonts-emoji
  liberation_ttf
*/



  fira-code
  #fira-code-symbols
  mplus-outline-fonts
  dina-font
  proggyfonts
  #(nerdfonts.override { fonts = [
    #"FiraCode"
    #"DroidSansMono"
  #  "nf-dev-coda"
  #]; })
];






# TODO microvm.nix -> ignite

#virtualisation.containerd.enable = true; # todo


  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      #dockerCompat = true;
    };
  };






  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80 443 # nginx
  ];


# https://nixos.wiki/wiki/Binary_Cache
# TODO ...
services.nginx = {
  enable = true;
  virtualHosts = {
    # ... existing hosts config etc. ...
#    "binarycache.laptop1" = {
    "nixos-cache.laptop1" = {
      serverAliases = [ "nixos-cache" ];
      locations."/".extraConfig = ''
        proxy_pass http://localhost:${toString config.services.nix-serve.port};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
};



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?










  environment.systemPackages = with pkgs; [
#    pkgs.nur.repos.mic92.hello-nur

gnome3.adwaita-icon-theme

# all gtk themes
adapta-gtk-theme
#cde-gtk-theme # broken
layan-gtk-theme
lounge-gtk-theme
matcha-gtk-theme
mojave-gtk-theme
numix-gtk-theme
numix-solarized-gtk-theme
numix-sx-gtk-theme
#### missing elementary-gtk-theme
paper-gtk-theme
pop-gtk-theme
sierra-gtk-theme
solarc-gtk-theme
vimix-gtk-themes
whitesur-gtk-theme

# qt themes
qtstyleplugin-kvantum-qt4
libsForQt5.qtstyleplugin-kvantum


# open lxappearance and pick your themes
  gtk-engine-murrine
  gtk_engines
  gsettings-desktop-schemas
  lxappearance




torsocks
tightvnc
    wget
    curl
    curl.dev # curl-config, needed by pyload
speedtest-cli

ipfs
#ipfs-desktop # TODO undefined

linuxPackages.cpupower

nix-index # nix-locate






mmv
pv # pipe view (progress, rate)
tree
onboard # virtual keyboard
iotop
killall
moreutils # sponge: soak up stdin/write to file
unzip
#html-tidy
bridge-utils # brctl -> network bridges







#monero-gui monero

expect # unbuffer

#    sane-backends # scanner, tool: scanimage







    ark # archive manager
p7zip
#unrar # unfree

    gwenview # image viewer

    git





    xfce.orage # calendar. TODO import old data! from ~/user-old



    spectacle



cloc # count lines of code

vscodium

meld # Visual diff and merge tool

    okular # document viewer

# ocr
gImageReader
hunspell # spell checker
hunspellDicts.de_DE
hunspellDicts.en_US-large

    # web browsers
    ungoogled-chromium
#    firefox # con: censorship?

#nixpkgs-2021-04-19.tor-browser-bundle-bin
#tor-browser-bundle-bin

tor-browser-bundle-bin

    mpv # video player

# TODO
#nur.repos.milahu.svn2github


    ffmpeg-full
    subdl # subtitle downloader
subtitleeditor
#    kdenlive # video editor
    youtube-dl
sox



    konsole
    dolphin # file manager

    nodejs_latest


    wireguard-tools

kate

qtcurve # qt themes
qt5ct # qtcontrol for qt5
breeze-qt5 # breeze-dark theme?

    libdeflate
    zlib
#    rubyPackages.nokogiri # huginn
    jq # json query

#    python2
    #python27Packages.pip

    python3


nftables # for wireguard


qbittorrent
#jdownloader # ddl manager

gst_all_1.gst-plugins-good # gstreamer plugins




  ];
}


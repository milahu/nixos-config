# TODO spotify, wg-quick + netns + piavpn

# TODO use only 2 of 4 cores for nix-build, to make laptop more quiet

# asdf

# TODO move all flakes stuff to flake.nix
#  nixpkgs.overlays = [ inputs.nur.overlay ];
# pin nixpkgs in the system-wide flake registry
#nix.registry.nixpkgs.flake = inputs.nixpkgs;

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, inputs, ... }:

{

  imports = [

    ./hardware-configuration.nix

    ./cachix.nix # cachix use nix-community

    #./modules/services/networking/pure-ftpd.nix # poor config
    #./modules/services/networking/proftpd.nix
    /home/user/src/nixos/milahu--nixos-packages/nur-packages/modules/services/networking/proftpd.nix

  ];

  nixpkgs.overlays = [

    (pkgz: pkgs: {
      #proftpd = pkgs.callPackage ./pkgs/proftpd/proftpd.nix { };
      proftpd = pkgs.callPackage /home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/proftpd/nixpkgs/pkgs/servers/ftp/proftpd/default.nix { };
      #      jdownloader = pkgs.callPackage /home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/jdownloader {};

      /*
        firejail = pkgs.firejail.overrideAttrs (old: {
        #propagatedBuildInputs = old.propagatedBuildInputs ++ [ pkgs.iptables ];
        propagatedBuildInputs = [ pkgz.iptables pkgz.xorg.xauth pkgz.coreutils ];
        #src = /home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/jdownloader/src/firejail; # debug
        # intentionally without doublequotes, to also replace unquoted strings in printf format strings
        postPatch = ''
        # TODO automate patching of FHS binary paths
        sed -i 's|/sbin/iptables|${pkgz.iptables}/bin/iptables|' src/firejail/netfilter.c
        sed -i 's|/usr/bin/xauth|${pkgz.xorg.xauth}/bin/xauth|' src/firejail/x11.c
        #sed -i 's|/usr/bin/coreutils|${pkgz.coreutils}/bin/coreutils|' src/firejail/x11.c
        '';
        });
      */

      /*
      youtube-dl = pkgs.youtube-dl.overrideAttrs (old: {
        # fix: Unable to extract Initial JS player n function name
        patches = [ ];
        version = "unstable-2022-05-10"; # not used 0__o
        src = pkgz.fetchFromGitHub {
          owner = "ytdl-org";
          repo = "youtube-dl";
          rev = "c7965b9fc2cae54f244f31f5373cb81a40e822ab";
          sha256 = "sha256-PrXo8mNlNTD+Fjcb93LUsY5huAR9UCcvR/ujb3zT+1g=";
        };
        postInstall = ""; # fix: youtube-dl.zsh no such file
      });
      */

    })

    # no effect??
    # has effect only on nixos modules? (but not on system env packges)
    (pkgz: pkgs: {

      /*
        gstreamermm = pkgs.gstreamermm.overrideAttrs (old: {
        # https://github.com/NixOS/nixpkgs/pull/171274
        #patches = [ ./gstreamermm-fix-build.patch ];
        # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/libraries/gstreamer/gstreamermm/default.nix
        pname = "gstreamermm";
        version = "unstable-2021-09-15";
        src = pkgz.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        #group = "gnome";
        owner = "GNOME";
        repo = "gstreamermm";
        rev = "dfd80ddb4eac02ae6c48a076a9cd9a1dc9e7bed2";
        sha256 = "sha256-4VwVyu0RzvtsTq/UWZ3//KCY0qxfMrdqDCpMnEGe9YA=";
        };
        });
      */

      /* subtitleeditor (not needed any more)
        gstreamermm = pkgs.gstreamermm.overrideAttrs (old: {
        # https://github.com/NixOS/nixpkgs/pull/171274

        # https://github.com/NixOS/nixpkgs/pull/171274#issuecomment-1119011973
        patches = [
        # For GCC11 compatibility.
        (pkgz.fetchpatch {
        url = "https://gitlab.gnome.org/GNOME/gstreamermm/-/commit/37116547fb5f9066978e39b4cf9f79f2154ad425.patch";
        sha256 = "sha256-YHtmOiOl4POwas3eWHsew3IyGK7Aq22MweBm3JPwyBM=";
        })
        ];
        });
      */
    })

  ]; # nixpkgs.overlays

# https://nixos.wiki/wiki/Storage_optimization
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};

  # Override select packages to use the unstable channel
/* no effect -> move to flake.nix
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/1ed7701bc2f5c91454027067872037272812e7a3.tar.gz") {
      inherit pkgs;
    };
  };
*/

  # dont build nixos-manual-html (etc)
  documentation.doc.enable = false;
  documentation.nixos.enable = false;

  #services.sshd.enable = true;

# https://nixos.wiki/wiki/SSH_public_key_authentication
services.openssh = {
  enable = true;
  settings = {
    # require public key authentication for better security
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    #PermitRootLogin = "yes";
  };
};

  # ipfs
  #services.kubo.enable = true;

  # nixpkgs/nixos/modules/services/databases/postgresql.nix
  # nixpkgs/pkgs/servers/sql/postgresql
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    #extraPlugins = with pkgs.postgresql.pkgs; [ ];
    # map-name system-username database-username
    identMap = ''
      idmap1 user user
    '';
  };

  /*
    # TODO use distcc to distribute ALL builds across multiple machines ("build farm")
    services.distccd = {
    enable = true;
    allowedClients = [ "127.0.0.1" "192.168.1.0/24" ];
    openFirewall = true;
    zeroconf = true;
    };
  */

  networking.hostName = "laptop1";

  /* replaced with tigervnc
    nixpkgs.config.permittedInsecurePackages = [
    "tightvnc-1.3.10"
    ];
  */

  # my ISP (deutsche telekom) is censoring some websites via DNS. fuck censorship.
  # FIXME not used in /etc/resolv.conf. blame VPN?
  networking.nameservers = [
    # cloudflare DNS
    "1.1.1.1"
    "1.0.0.1"
    # google DNS
    "4.4.4.4"
    "8.8.4.4"
    # ?
    #"9.9.9.9"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-12.22.12" # TODO who needs nodejs 12? pkgs.nodejs-12_x
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #"osu-lazer"
    #"flashplayer"
    #"vscode" # -> vscodium
    "rar"
    "unrar"
    "brgenml1lpr" # brother printer
    "brother-hll3210cw" # brother printer
# hll6400dwlpr-3.5.1-1
"brother-hll6400dw-lpr"
    #"cups-kyocera-ecosys-m552x-p502x" # kyocera p5021cdn printer
    #"cnijfilter2" # canon printer: cnijfilter2-6.10
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

  # https://github.com/NixOS/nix/pull/7283
/*
  nix.package = pkgs.nixUnstable.overrideAttrs (old: {
    src = inputs.nixSource;
    #version = "2.13.0";
    # some tests are failing because of extra debug output
    #doCheck = false; # no effect
    doInstallCheck = false;
  });
*/
  #nix.package = pkgs.nixVersions.nix_2_7;

  # https://nixos.wiki/wiki/Distributed_build
  # TODO distcc??
  #     nix.buildMachines = if false then [
  nix.buildMachines =
    if true then [] else [
      #/xx* laut
      {
        #hostName = "laptop2";
        hostName = "jonringer"; # /home/user/.ssh/config
        # TODO port = 2222;

        system = "x86_64-linux";
        maxJobs = 1;
        #speedFactor = 2;
        speedFactor = 40; # 30x faster than laptop2
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
      192.168.1.191 laptop1
      192.168.1.120 laptop2
      #73.157.50.82 jonringer
    '';

  /*
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nixos/nixos-cache/cache-priv-key.pem";
    # /etc/nixos/nixos-cache/cache-pub-key.pem
  };
  */

  fileSystems."/" =
    {
      # TODO inherit device UUID from ,/hardware-configuration.nix
      #device = "/dev/disk/by-uuid/2e0a16b9-e026-4e69-8640-a2b2ce6d45bf"; # old SSD (240 GB)
      device = "/dev/disk/by-uuid/141c3965-7393-4459-ab03-ae90173d984f";
      fsType = "ext4";
      options = [
        "rw"
        "data=ordered" # faster than journal, slower than writeback
        #"relatime" # slower than noatime, update atime only after file was modified
        "noatime"
        "nodiratime" # dont write access time -> faster
      ];
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

  # TODO add fancontrol service
  # power management
  # TODO add to
  # https://nixos.wiki/wiki/Power_Management
  # https://nixos.wiki/wiki/Thinkpad
  # https://discourse.nixos.org/t/thinkpad-t470s-power-management/8141/3
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/tasks/cpu-freq.nix
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/power-management.nix # -> standby + resume
  # https://wiki.archlinux.org/title/fan_speed_control
  # https://www.thinkwiki.org/wiki/How_to_control_fan_speed
  # https://discourse.nixos.org/t/correct-way-to-use-lm-sensors-in-nixos/10139
  #   https://discourse.nixos.org/t/fan-keeps-spinning-with-a-base-installation-of-nixos/1394/3
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/fancontrol.nix
  #boot.initrd.availableKernelModules = [
  boot.kernelModules = [
    "thinkpad_acpi" # TODO fan_control=1

    # TODO fix cpupower. not working with intel_cpufreq
    # https://wiki.archlinux.org/title/CPU_frequency_scaling
    # https://www.thinkwiki.org/wiki/Problem_with_CPU_frequency_scaling
    # https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html?highlight=intel_cpufreq
    "acpi_cpufreq"
    # TODO blacklist intel_pstate module
    # or kernel cmdline: intel_pstate=disable
    # https://unix.stackexchange.com/questions/650873
    # rmmod intel_pstate
    # rmmod: ERROR: Module intel_pstate is builtin.

    "coretemp"
    "cpuid"
  ];
  #hardware.cpu.intel.updateMicrocode = true;
  #boot.kernelModules = [ "coretemp" "cpuid" ];

  boot.kernelParams = [
    "intel_pstate=disable" # instead, use acpi_cpufreq for cpupower
  ];

  services.upower.enable = true;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    #cpufreq.max = "800MHz"; # cpupower frequency-set --max $max
    cpufreq.max = 1600 * 1000; # KHz # cpupower frequency-set --max $max
    # $ cpupower frequency-info
    # analyzing CPU 0:
    #   driver: intel_cpufreq
    #   hardware limits: 800 MHz - 3.20 GHz
  };
  powerManagement.powertop.enable = true;
  #services.thermald.enable = true; # FIXME build error
  environment.etc."sysconfig/lm_sensors".text = ''
    # Generated by sensors-detect
    HWMON_MODULES="coretemp"
  '';

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

  # kde login
  services.xserver.displayManager.sddm.enable = true;

  # kde desktop
  # breaks GTK apps: inkscape evolution
  services.xserver.desktopManager.plasma5.enable = true;
  # broken since setting dpi to 144 ... login hangs with black screen
  # broken. desktop hangs again and again ...
  # -> $HOME/bin/plasmashell-restart.sh

  # xfce desktop
  # FIXME keeps crashing over night
  # in the morning, i have a black screen
  # and must restart the display-manager.service
  # -> kde plasma
  #services.xserver.desktopManager.xfce.enable = true;

  # gnome login
  # broken: display-manager.service hangs at "starting X11 server..."
  #services.xserver.displayManager.gdm.enable = true;

  # gnome desktop
  # gnome is still gay.
  # gnome is still SHIT. gnome-shell still has a memory leak -> needs 2.6 GByte RAM after some days of uptime
  # cannot scale display to 150% (only 100% or 200%)
  # terminal is gay (cannot rename tabs)
  # -> back to kde
  #services.xserver.desktopManager.gnome.enable = true;

  # gnome
  /*
    environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    #gnome-terminal
    gedit
    epiphany
    #evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
    geary
    ]);
  */

  # gnome
  # fix:  dconf-WARNING **: failed to commit changes to dconf: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name ca.desrt.dconf was not provided by any .service files
  #programs.dconf.enable = true;

  # gnome
  #services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # cinnamon desktop
  #  services.xserver.desktopManager.cinnamon.enable = true; # would set qt5.style = "adwaita"

  # xfce would enable only qt4, see: env | grep QT_
  /* this breaks xfce desktop, cannot login
    qt5 = {
    enable = true;
    platformTheme = "gnome"; # fix: qt5.platformTheme is used but not defined
    style = "adwaita-dark"; # fix: qt5.style is used but not defined
    };
  */

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
  /*
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
  */

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

  # journalctl --catalog --follow --unit=cups
  services.printing.logLevel = "debug";

  # discover network printers
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # discover wifi printers
  services.avahi.openFirewall = true;

  #services.printing.extraConf = ''LogLevel debug'';
  # systemctl status -l cups.service

  services.printing.drivers =
    let
      # TODO:    nur.repos.milahu.brother-hll3210cw # brother HL-L3210CW
      #brother-hll3210cw = (pkgs.callPackage /home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/brother-hll3210cw/default.nix { });
    in
    [
      #    pkgs.gutenprint
      #    pkgs.gutenprintBin # canon etc
      #pkgs.hplip pkgs.hplipWithPlugin # hp
      #pkgs.samsungUnifiedLinuxDriver pkgs.splix # samsung

      pkgs.brlaser # brother # not?
      #    brother-hll3210cw
      pkgs.brgenml1lpr # brother # TODO

# hll6400dwlpr-3.5.1-1
/*
(pkgs.callPackage /home/user/src/nixpkgs/brother-hl-l6400dw/nixpkgs/pkgs/misc/cups/drivers/brother/hll6400dw/default.nix {}).driver
(pkgs.callPackage /home/user/src/nixpkgs/brother-hl-l6400dw/nixpkgs/pkgs/misc/cups/drivers/brother/hll6400dw/default.nix {}).cupswrapper
*/
(pkgs.callPackage /home/user/src/nixpkgs/brother-hl-l6400dw/nixpkgs/pkgs/misc/cups/drivers/brother/hll6400dw/default.nix {})

      # samsung
      pkgs.gutenprint
      pkgs.gutenprintBin

      #pkgs.cups-kyocera-ecosys-m552x-p502x # kyocera p5021cdn

      #pkgs.cnijfilter2 # filter program for canon pixma g5050, etc
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
    #mplus-outline-fonts # error: A definition for option `fonts.fonts.[definition 1-entry 2]' is not of type `path'. Definition values:
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

  # needed for
  # https://github.com/LanikSJ/dfimage
  # https://github.com/mrhavens/Dedockify
  # https://github.com/CenturyLinkLabs/dockerfile-from-image
  # -> reverse-engineer https://hub.docker.com/layers/sharelatex/sharelatex
  #virtualisation.docker.enable = true;

  /*
    virtualisation = {
    podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    #dockerCompat = true;
    };
    };
  */

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
    80
    443 # nginx
    #21 # ftpd

    #138 # NetBIOS Datagram
    #139 # NetBIOS Session
    #389 # LDAP
    #445 # SMB over TCP = samba
    #5357 # samba-wsdd
  ];

  networking.firewall.allowedUDPPorts = [
    #3702 # samba-wsdd
  ];

  networking.firewall.allowedTCPPortRanges = [
    #{ from = 51000; to = 51999; } # ftpd passive mode
  ];

  services.proftpd = {
    #enable = true;
    enable = false;
    name = ''quotes " test'';
    #extraConfig = builtins.readFile ./proftpd.conf;
    extraConfig = ''
      # no chmod
      <Limit SITE_CHMOD>
        DenyAll
      </Limit>
      # anon only
      <Limit LOGIN>
        DenyAll
      </Limit>
      <Anonymous /home/user/down/torrent/seed/Heimat.Defender.2021.Kvltgames.EinProzent>
        <Limit LOGIN>
          AllowAll
        </Limit>
        User				user
        Group				users
        #UserAlias			anonymous ftp
        UserAlias			anonymous user
        #RequireValidShell off
        # read only
        <Limit WRITE>
          DenyAll
        </Limit>
      </Anonymous>
    '';
  };

  /*
    services.pure-ftpd = {
    #  enable = true;
    args = [
    "--anonymousonly"
    "--chrooteveryone"
    "--daemonize"
    "--tls" "0" # 
    # 0:no TLS
    # 1:TLS+cleartext
    # 2:enforce TLS |
    # 3:enforce encrypted data channel as well
    "--ipv4only"
    "--maxclientsnumber" "1"
    "--verboselog"
    ];
    };
  */

  # FTP server
  services.vsftpd = {
    #    enable = true;
    extraConfig = ''
      pasv_enable=YES
      pasv_min_port=51000
      pasv_max_port=51999

      local_root=/home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/autosub-by-abhirooptalasila

      chroot_local_user=YES
      # no effect. allow_writeable_chroot=YES
      # disable "cd .."

      anon_root=/home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/autosub-by-abhirooptalasila

      guest_enable=YES
      guest_username=user
      ftp_username=user

      write_enable=NO
      # default YES

      #anonymous_enable=NO
      anonymous_enable=YES
      # default YES

      # debug
      log_ftp_protocol=YES
      xferlog_enable=YES
      xferlog_std_format=NO

      #local_root=/tmp/ftp-root # default $HOME
      #anon_root=/tmp/ftp-root
    '';
    # minimal secure setup:
    userlistDeny = false;
    localUsers = true;
    userlist = [ "non-root-user" "other-non-root-user" ];
    #forceLocalLoginsSSL = true;
    #forceLocalDataSSL = true;
    #rsaCertFile = "/var/vsftpd/vsftpd.pem";
  };

  # https://nixos.wiki/wiki/Binary_Cache
  # TODO ...
  /*
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
  */

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  /* fuck this. not working with windows 10 client.
    # https://nixos.wiki/wiki/Samba#Samba_Server
    services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
    workgroup = WORKGROUP
    server string = smbnix
    netbios name = smbnix
    security = user 

    # TODO disable?
    #use sendfile = yes
    #max protocol = smb2

    #protocol = SMB3

    # fix NT_STATUS_INVALID_NETWORK_RESPONSE

    #server min protocol = LANMAN1

    server min protocol = smb2
    server max protocol = smb3

    client min protocol = smb2
    client max protocol = smb3

    hosts allow = 192.168.1 127.0.0.1 localhost # localhost is ipv6
    #hosts allow = 192.168.1 localhost
    hosts deny = 0.0.0.0/0
    guest account = nobody
    map to guest = bad user
    '';
    shares = {
    autosub = {
    path = "/home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/autosub-by-abhirooptalasila";
    browseable = "yes";
    "read only" = "yes";
    #"guest ok" = "yes";
    #"create mask" = "0644";
    #"directory mask" = "0755";
    #"force user" = "username";
    #"force group" = "groupname";
    };
    };
    };
    services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
    services.samba.openFirewall = true;
  */

  /*
    security.setuidPrograms = [
    "firejail" # fix: Error mkdir: util.c:1141 create_empty_dir_as_root: Permission denied
    ];
    security.wrappers
  */
  #programs.firejail.enable = true;

  /*
    noblacklist ${HOME}/.jd

    # Allow java (blacklisted by disable-devel.inc)
    include allow-java.inc

    mkdir ${HOME}/.jd
    whitelist ${HOME}/.jd

    include chromium.profile
  */

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      /*
        jdownloader = {
        executable = "${pkgs.jdownloader}/bin/jdownloader";
        profile = "${pkgs.firejail}/etc/firejail/jdownloader.profile"; # JDownloader.profile ?
        extraArgs = [
        #"--ignore=private-dev"
        "--name=jdownloader" # firejail --join=jdownloader bash
        #"--x11=xpra" # fail: jd has access to clipboard
        "--x11=xorg" # fail: jd has access to clipboard
        ];
        };
      */

      /*
        JDownloader can't execute web browser
        https://github.com/netblue30/firejail/issues/2336

        Try creating ~/.config/firejail/JDownloader.profile:

        ```
        noblacklist ${HOME}/.jd

        # Allow java (blacklisted by disable-devel.inc)
        include allow-java.inc

        mkdir ${HOME}/.jd
        whitelist ${HOME}/.jd

        include chromium.profile
        ```
      */
    };
  };

  # TODO
  #programs.unity3d.enable = true; # -> security.chromiumSuidSandbox.enable
  security.chromiumSuidSandbox.enable = true;
  #programs.unityhub.enable = true; # does not exist

  #############################################################################################
  #############################################################################################
  #############################################################################################
  #############################################################################################
  #############################################################################################

  environment.systemPackages = with pkgs; [

    #subtitleeditor # TODO test with patched gstreamermm
    # ^^ crap. use gaupol


    #    pkgs.nur.repos.mic92.hello-nur

    # TODO whats the difference?
    #nur.repos.sigprof.vdhcoapp # 1.6.3
    #nur.repos.wolfangaukang.vdhcoapp # 1.6.3 # TODO

    #firejail # security

    #xpra # firejail --x11=xpra
    #xorg.xauth # firejail --x11=xorg

    /*
      (xpra.overridePythonAttrs (old: {
      # /home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/jdownloader/jdownloader-in-firejail.nix
      # https://github.com/NixOS/nixpkgs/issues/122159
      postFixup = ''
      cat >$out/bin/xpra.polyglot <<EOF
      $(head -n1 $out/bin/xpra)
      # polyglot: bash + python
      """:"
      # bash
      export XORG_CONFIG_PREFIX="" # fix: Cannot open /dev/tty0 https://github.com/NixOS/nixpkgs/issues/161975
      $(tail -n +2 $out/bin/xpra)
      exit
      """
      # python
      $(cat $out/bin/.xpra-wrapped)
      EOF
      mv $out/bin/xpra.polyglot $out/bin/xpra
      chmod +x $out/bin/xpra
      '';
      }))
    */

    #gnome3.adwaita-icon-theme
    #gnomeExtensions.appindicator

    # all gtk themes
    /*
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
    */

    # qt themes
    /*
      qtstyleplugin-kvantum-qt4
      libsForQt5.qtstyleplugin-kvantum
    */

    /*
      # open lxappearance and pick your themes
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
    */

    torsocks
    #tightvnc # -> tigervnc

    wget
    curl
    curl.dev # curl-config, needed by pyload
    #speedtest-cli

    #ipfs
    #ipfs-desktop # TODO undefined

    # chat
    #element-desktop
    #tdesktop # telegram
    hexchat # irc
    #whatsapp-for-linux

    linuxPackages.cpupower

    nix-index # nix-locate
    cached-nix-shell # Instant startup time for nix-shell

    gimp

    #inkscape
    # https://github.com/NixOS/nixpkgs/issues/197044
    (inkscape-with-extensions.override {
      inkscapeExtensions = with inkscape-extensions; [
        applytransforms
      ];
    })

    strawberry # music player
    #calibre # ebook converter

    screen
    tmux

    mmv # multi move
    pv # pipe view (progress, rate)
    tree
    onboard # virtual keyboard
    killall
    unixtools.xxd # encode/decode hex strings to/from bytes
    moreutils # sponge: soak up stdin/write to file
    unzip
    #html-tidy # old shit
    bridge-utils # brctl -> network bridges

    #monero-gui monero

    expect # unbuffer

    sane-backends # scanner, tool: scanimage

    usbutils # lsusb

    imagemagick # convert

    ark # kde archive manager
    p7zip
    unrar # unfree

sox # audio tool

    gwenview # image viewer

    git
    #git-lfs # upload large files (>100MB) to github
    #git-repo-filter # delete files in git history
    git-filter-repo # deprecated: git filter-branch

    #xfce.orage # calendar. TODO import old data! from ~/user-old

    spectacle # screenshot

    cloc # count lines of code

#vscode

    # vscodium 1.72
    # https://github.com/NixOS/nixpkgs/pull/194860
    # TODO build from source
    # /home/user/src/nixpkgs/pkgs/applications/editors/vscode/oss.nix
    # /home/user/src/nixpkgs/vscode.md
    (vscodium.overrideAttrs (old: (
      let
        sha256 = {
          x86_64-linux = "1r7k20j51z0y967qm0fnajf1lwjsgxj81p0qh46hsy76q3d793wm";
          x86_64-darwin = "1s7k06sm7890bkim6h1vrywcia8fayvmpy1cchy5kvz2pks9y9pf";
          aarch64-linux = "0san532jc3f9k23dlccb4b3pf7b97jylzdvb8l9mq4a18s3rg5s2";
          aarch64-darwin = "1zzpjgvxam4pmp3wh8aj9cly46m74h93zn21ql7wy347cpzx4b05";
          armv7l-linux = "1phaaq4kg9cn1aq3jg9v1a98iwgvc31s6d0r5w3nzn2wmfbr4pjz";
        }.${system} or throwSystem;
        plat = {
          x86_64-linux = "linux-x64";
          x86_64-darwin = "darwin-x64";
          aarch64-linux = "linux-arm64";
          aarch64-darwin = "darwin-arm64";
          armv7l-linux = "linux-armhf";
        }.${system} or throwSystem;
        archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";
      in
      rec {
        version = "1.72.0.22279";
        src = fetchurl {
          url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
          inherit sha256;
        };
      })))

    clang-tools # clangd = c/cpp lang server
    #rnix-lsp # nix lang server for vscodium # old? build from git

    #meld # Visual diff and merge tool

    okular # document viewer, ebook reader
    #libreoffice
    #abiword

    # ocr
    gImageReader
    hunspell # spell checker
    hunspellDicts.de_DE
    hunspellDicts.en_US-large

    # web browsers
    ungoogled-chromium # chrome. TODO perfect dark mode theme, like shadowfox for firefox
    #librewolf # firefox with better privacy
    #firefox # con: censorship?
    #shadowfox # perfect dark mode theme for firefox. install theme with shadowfox-updater # unfree

    #evolution # email
    #hydroxide # email bridge/proxy for protonmail.com. ~/bin/_protonmail_bridge # broken?

    #nixpkgs-2021-04-19.tor-browser-bundle-bin
    tor-browser-bundle-bin # TODO use cached

    mpv # video player

    # TODO
    #nur.repos.milahu.svn2github

    #nur.repos.milahu.srtgen
    #(callPackage ./pkgs/srtgen { })

    ffmpeg-full
    subdl # subtitle downloader

    #subtitleeditor # -> gaupol
    #nur.repos.milahu.gaupol # TODO update nur

    #(subtitleeditor.override { gstreamermm = gstreamermm_patched; }) # unexpected arg: gstreamermm

    #    kdenlive # video editor
    #youtube-dl
    yt-dlp # youtube-dl fork
    #sox

    konsole
    #    dolphin # qt file manager

    nodejs_latest

    wireguard-tools

    #kate

    /*
      qtcurve # qt themes
      qt5ct # qtcontrol for qt5
      breeze-qt5 # breeze-dark theme?
    */

    libdeflate
    zlib
    #    rubyPackages.nokogiri # huginn
    jq # json query

    #    python2
    #python27Packages.pip

    #    python3 # test: ~/src/nixos/nix-review/nixpkgs-review -> use python3 from default.nix
    #python3 # needed for inkscape (save as optimized svg)
    #python3.pkgs.packaging # not working in inkscape
    #(python3.withPackages (pp: with pp; [ packaging ])) # not working in inkscape

    # python2
    #(python.withPackages (pp: with pp; [ packaging ])) # not working in inkscape
    #python # needed for inkscape (save as optimized svg)
    #python.pkgs.packaging # not working in inkscape

    nftables # for wireguard

    qbittorrent # TODO vpn only for this app
    #jdownloader # ddl manager

    gst_all_1.gst-plugins-good # gstreamer plugins

    #cachix # cachix use nix-community
    # Enable the Nix Community cache:
    # https://github.com/nix-community/redoxpkgs

    htop # monitor cpu + memory
    iotop # monitor disks
    nethogs # monitor network by process
    iftop # monitor network by connection
    nmap # network port scanner

    bintools-unwrapped # nm strings ...
    file
    binwalk
    python3.pkgs.matplotlib # FIXME not found by binwalk
    #gdb
    strace
    ltrace
    gdb
    binwalk
    lsof

    #ruplacer # replace fixed strings. similar: rpl

    # TODO: jaq # alternative to jq

    nix-prefetch-github

    thinkfan # laptop fan control
    lm_sensors # sensors: temperature ...
    smartmontools # smartctl: hard drive health status

    direnv # use .envrc files

    # /home/user/src/wireguard/pia-foss/manual-connections/python-piavpn/
    python3 python3.pkgs.cerberus python3.pkgs.pyaml python3.pkgs.requests python3.pkgs.tzlocal python3.pkgs.async-timeout python3.pkgs.pygeoip geolite-legacy

    xclip

    libjpeg # jpegtran, lossless jpeg transforms

    rar
    unrar

    nixpkgs-fmt

    wine # for ida.exe

    #github-desktop

    qt6.qttools # designer
    qt6.qttools.dev # designer

    patchelf

  ];
}

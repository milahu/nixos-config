# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # add printers
  # https://nixos.wiki/wiki/Printing#Adding_printers
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL-L5100DN_1";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5B30055cb7e60b%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-30055cb7e60b";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_10";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5Bb42200c3c310%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-b42200c3c310";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_11";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5Bb42200dd3472%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-b42200dd3472";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_12";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5B30055cb9745a%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-30055cb9745a";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_13";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5Bb42200dddbc6%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-b42200dddbc6";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_14";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-b42200c32d81";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_15";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5Bb42200dddca9%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-b42200dddca9";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_16";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5Bb4220007880b%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-b4220007880b";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_2";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5B3c2af4accce6%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-3c2af4accce6";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_4";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5B30055cb0ad6f%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-30055cb0ad6f";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_5";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5B3c2af4a4b0b2%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-3c2af4a4b0b2";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "Brother_HL-L5100DN_8";
        location = "Local Printer";
        deviceUri = "dnssd://Brother%20HL-L5100DN%20series%20%5B30055cb13942%5D._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-30055cb13942";
        model = "brother-HLL5100DN-cups-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };

  # journalctl --catalog --follow --unit=cups
  # services.printing.logLevel = "debug";

  # discover network printers
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

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
      #(pkgs.callPackage /home/user/src/nixpkgs/brother-hl-l6400dw/nixpkgs/pkgs/misc/cups/drivers/brother/hll6400dw/default.nix {})
      #pkgs.nur.repos.milahu.brother-hll6400dw
      pkgs.nur.repos.milahu.brother-hll5100dn
      #pkgs.nur.repos.milahu-local.brother-hll5100dn


      # samsung
      pkgs.gutenprint
      pkgs.gutenprintBin

      #pkgs.cups-kyocera-ecosys-m552x-p502x # kyocera p5021cdn

      #pkgs.cnijfilter2 # filter program for canon pixma g5050, etc
      #nixpkgs-2021-04-19.cnijfilter2 # filter program for canon pixma g5050, etc

      #canon-cups-ufr2
    ];

  # scanners
  hardware.sane = {
    enable = true;
    brscan4.enable = true;
    brscan5.enable = true;
  };
  #services.saned.enable = true;

  # increase size of /run/user/1000 (max = ram + swap = 8 + 16 = 24)
  # swap -> /etc/nixos/hardware-configuration.nix
  # https://unix.stackexchange.com/questions/597024/how-to-resize-the-run-directory
  services.logind.extraConfig = ''
    RuntimeDirectorySize=12G
    HandleLidSwitchDocked=ignore
  '';



  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # https://nixos.wiki/wiki/Fonts
  fonts.packages = with pkgs; [
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

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "user";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # https://nixos.wiki/wiki/SSH_public_key_authentication
  services.openssh = {
    enable = true;
    settings =
    #if true then { } else # INSECURE: allow password auth
    {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
  ];
  networking.firewall.allowedUDPPorts = [
  ];
  networking.firewall.allowedTCPPortRanges = lib.mkForce [
    { from = 6881; to = 6889; } # torrent default ports
  ];
  networking.firewall.allowedUDPPortRanges = lib.mkForce [
    { from = 6881; to = 6889; } # torrent default ports
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
    };
  };

  # ?
  security.chromiumSuidSandbox.enable = true;

  # https://wiki.nixos.org/wiki/Laptop#Hybrid_graphics
  # Nvidia Configuration
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable OpenGL
  hardware.graphics.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;

  hardware.nvidia.prime = {
    sync.enable = true;

    # this requires to modify bios config
    # from "discrete graphics" to "switchable graphics"
    # otherwise "lspci | grep VGA" shows only one entry

    # # lspci | grep VGA
    # 01:00.0 VGA compatible controller: NVIDIA Corporation TU117M [GeForce GTX 1650 Ti Mobile] (rev a1)
    # 04:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Renoir [Radeon Vega Series / Radeon Vega Mobile Series] (rev c6)

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    # option "amdBusId" does not exist
    intelBusId = "PCI:4:0:0";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # moved to flake.nix
  /*
  # https://github.com/nix-community/NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
  */

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    git-filter-repo
    tor-browser
    kdePackages.kate
    vdhcoapp
    dig
    speedtest-cli

    # chat
    element-desktop # matrix. heavy...
    tdesktop # telegram
    session-desktop
    pidgin
    pidgin-otr # off the record
    #(pidgin.withPlugins (p: with p; [ ... ])) # ?
    hexchat # irc
    #whatsapp-for-linux
    #bitmessage # TODO
    #zeronet # FIXME insecure

    # tor hidden chat
    nur.repos.milahu.ricochet-refresh

    #linuxPackages.cpupower

    nix-index # nix-locate
    #cached-nix-shell # Instant startup time for nix-shell

    gimp

    #inkscape
    # https://github.com/NixOS/nixpkgs/issues/197044
    (inkscape-with-extensions.override {
      inkscapeExtensions = with inkscape-extensions; [
        applytransforms
      ];
    })

    #nodePackages.svgo # svg optimizer

    # trace bitmaps to vector graphics
    #autotrace
    #potrace

    strawberry # music player
    mixxx # music player, DJ tool
    audacity # audio editor
    sox # audio tool
    bpm-tools


    #calibre # ebook converter, epub reader?

    #screen
    #tmux

    mmv # multi move
    pv # pipe viewer (progress, rate)
    tree
    onboard # virtual keyboard
    killall
    unixtools.xxd # encode/decode hex strings to/from bytes

    # TODO moreutils without parallel or rename to parallel.moreutils like in ubuntu/debian
    moreutils # sponge: soak up stdin/write to file

    # hiPrio to solve the bin/parallel conflict between parallel and moreutils
    # https://askubuntu.com/questions/1191516/what-happens-to-usr-bin-parallel-if-i-install-the-moreutils-on-top-of-the-paral
    # https://discourse.nixos.org/t/how-to-deal-with-conflicting-packages/12505 # hiPrio
    # https://discourse.nixos.org/t/install-a-package-but-only-specific-binaries/18832 # linkFarm
    # FIXME this will still prefer the manpage of moreutils parallel
    # because parallel has no manpage
    # find /nix/store/zwz1j8ll48b5gibb6x543hplgbn1vbdd-parallel-20230822/ -type f
    # there still is /nix/store/2zza3l6h69zfkxrcx2pmr3a5cppkya1d-moreutils-0.67/bin/parallel
    # but the symlink /run/current-system/sw/bin/parallel
    # points to /nix/store/3mf4h4bcp6m8rsv5xq2k9dlz5hp0xsfz-parallel-full/bin/parallel
    # the package name "parallel-full" is confusing
    # parallel-full has only bin/parallel
    # which is a wrapper for parallel/bin/parallel
    # the wrapper only sets the PERL5LIB path
    # manpages are installed to /nix/store/ld9gda11l94qmy0y00g7854nrsrv54v2-parallel-20231022-man
    (hiPrio parallel.man)

    (hiPrio (hiPrio
      (parallel-full.override {
        # because nixpkgs maintainers are pussies
        # and dont simply remove the "will cite" nag shit
        # fuck i hate polite people...
        # https://github.com/NixOS/nixpkgs/issues/110584
        # https://github.com/NixOS/nixpkgs/pull/110633
        willCite = true;
        /*
        parallel = parallel.overrideAttrs (oldAttrs: {
          # also install man pages
          postInstall = ''
            make install-man
            wrapProgram $out/bin/parallel \
              --prefix PATH : "${lib.makeBinPath [ procps perl coreutils gawk ]}"
          '';
        });
        */
      })
    ))

    unzip
    zip # deflate
    brotli
    zstd
    bzip2
    bzip3
    xz # lzma
    rar
    p7zip # 7z # TODO replace with _7zz? https://github.com/p7zip-project/p7zip/issues/225
    p7zip.doc
    #lzham
    lz4
    #lrzip
    #zpaq
    libarchive # bsdtar, bsdcpio
    #nur.repos.milahu.cmix
    #nur.repos.milahu.lzturbo
    #peazip # gui multi format archiver: 7Z, 7-Zip sfx, ACE, ARJ, Brotli, BZ2, CAB, CHM, CPIO, DEB, GZ, ISO, JAR, LHA/LZH, NSIS, OOo, PEA, RAR, RPM, split, TAR, Z, ZIP, ZIPX, Zstandard

    /*
    nur.repos.milahu.mediawiki-dumper
    */

    nur.repos.milahu.vtt2clean-srt

    pinentry
    pinentry.qt

    # also used by nur.repos.milahu.pdfjam
    #texlive.combined.scheme-small
    #texlive.combined.scheme-medium # pdfcrop

    pandoc
    #nur.repos.milahu.pandoc-bin

    qrtool # qrcode encoder + decoder

    html-tidy # fix broken html files

    # these require texlive (texlive-combined-small) -> slow
    /*
    nur.repos.milahu.pdfjam
    nur.repos.milahu.pdfjam-extras # pdfnup
    nur.repos.milahu.pdfselect
    */

    # FIXME python3.11-python-poppler-qt5> NameError: name 'SocstringSignature' is not defined. Did you mean: 'DocstringSignature'?
    #nur.repos.milahu.krop # crop pdf files

    # generate subtitles for video files
    #nur.repos.milahu.autosub-by-abhirooptalasila
    # FIXME build
    #nur.repos.milahu.autosub
    #html-tidy # old shit
    #bridge-utils # brctl -> network bridges

    expect # unbuffer

    sane-backends # scanner, tool: scanimage
    sane-frontends # scanadf

    usbutils # lsusb
    pciutils # lspci

    imagemagick # convert

    # better than imagemagick for jp2 images?
    # img2pdf -o sample.pdf sample.jp2
    python3Packages.img2pdf

    #ark # kde archive manager

    #gwenview # image viewer # FIXME broken
    feh # image viewer # TODO less lightweight?

    #xfce.orage # calendar. TODO import old data! from ~/user-old

    kdePackages.spectacle # screenshot

    #cloc # count lines of code

    #vscode

    # vscodium 1.72
    # https://github.com/NixOS/nixpkgs/pull/194860
    # TODO build from source
    # /home/user/src/nixpkgs/pkgs/applications/editors/vscode/oss.nix
    # /home/user/src/nixpkgs/vscode.md

    vscodium
    # TODO nixos configuration "nixd" "vscodium" "home-manager" "settings.json" "nix.serverSettings"
    # https://discourse.nixos.org/t/nixd-nix-language-server/28910
    # ^ not helpful. still requires manually editing vscode config files (?)

    kdePackages.okular # document viewer, ebook reader

    libreoffice-fresh # newer version than libreoffice?
    # libreoffice: 7.4.7.2
    # libreoffice-fresh: TODO

    #abiword
    pdftk
    poppler_utils # pdfimages
    # FIXME        error: undefined variable 'requests'
    #nur.repos.milahu.archive-org-downloader # rip PDFs from archive.org
    #ghostscript # part of texlive.combined.scheme-medium
    #gv # ghostscript viewer

    # ocr
    tesseract
    ocrmypdf
    gImageReader
    hunspell # spell checker
    hunspellDicts.de_DE
    hunspellDicts.en_US-large

    # web browsers
    ungoogled-chromium # chrome. TODO perfect dark mode theme, like shadowfox for firefox
    librewolf # firefox with better privacy
    #firefox # con: censorship?
    #shadowfox # perfect dark mode theme for firefox. install theme with shadowfox-updater # unfree

    #evolution # email
    #hydroxide # email bridge/proxy for protonmail.com. ~/bin/_protonmail_bridge # broken?

    #tor-browser
    # fix: browse files for file upload makes tor browser hang with periodic flashes
    # https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/42561
    #nur.repos.milahu.tor-browser_13_0_13

    mpv # video player

    # TODO


    #nur.repos.milahu.srtgen
    #(callPackage ./pkgs/srtgen { })

    # TODO why is this the old version 5 ffmpeg?
    # /nix/store/0karag24idgs2ngpv69yr1n6srvf254i-ffmpeg-full-5.1.3-bin/bin/ffmpeg
    #ffmpeg-full
    ffmpeg_6-full
    mlt # high-level interface to ffmpeg https://www.mltframework.org/
    fdk-aac-encoder # fdkaac # avoid compiling ffmpeg with libfdk_aac
    rubberband # change tempo and pitch of audio, timestretch
    #subdl # subtitle downloader
    #nur.repos.milahu.subdl # subtitle downloader
    #nur.repos.milahu-local.subdl # subtitle downloader

    aegisub # subtitles editor
    subtitleeditor # -> gaupol
    nur.repos.milahu.gaupol # subtitles editor # crap, but better than aegisub

    #nur.repos.milahu.ffsubsync # auto-sync subtitles to video

    #(subtitleeditor.override { gstreamermm = gstreamermm_patched; }) # unexpected arg: gstreamermm

    #kdenlive # video editor
    #youtube-dl # old -> yt-dlp
    #yt-dlp # youtube-dl fork
    nur.repos.milahu.yt-dlp

    kdePackages.konsole
    #    dolphin # qt file manager

    nodejs_latest


    libdeflate
    zlib

    #    rubyPackages.nokogiri # huginn
    jq # json query
    gron # make json greppable

    #ast-grep # grep for syntax trees

    #    python2
    #python27Packages.pip

    (if true then python3 else (python3.withPackages (pp: with pp; [
      #packaging
      # /home/user/doc/alchi/git/alchi/src/whoaremyfriends
      #argostranslate
      #translatehtml
      # piavpn
      # /home/user/src/wireguard/pia-foss/manual-connections/python-piavpn/
      /*
      cerberus
      pyaml
      requests
      tzlocal
      async-timeout
      pygeoip
      geolite-legacy
      */

      #isort # vscodium # not working?
    ])))


    qbittorrent # TODO vpn only for this app
    #jdownloader # ddl manager

    #soulseekqt # filesharing

    gst_all_1.gst-plugins-good # gstreamer plugins

    #cachix # cachix use nix-community
    # Enable the Nix Community cache:
    # https://github.com/nix-community/redoxpkgs

    htop # monitor cpu + memory
    iotop # monitor disks
    #nethogs # monitor network by process
    #iftop # monitor network by connection
    nmap # network port scanner

    bintools-unwrapped # nm strings ...
    file
    binwalk
    #python3.pkgs.matplotlib # FIXME not found by binwalk
    strace
    ltrace
    gdb
    binwalk
    lsof

    #ruplacer # replace fixed strings. similar: rpl

    # TODO: jaq # alternative to jq

    #nix-prefetch-github

    thinkfan # laptop fan control
    lm_sensors # sensors: temperature ...
    smartmontools # smartctl: hard drive health status

    #direnv # use .envrc files

    xclip

    libjpeg # jpegtran, lossless jpeg transforms

    fbida # exiftran, lossless jpeg transforms

    nixpkgs-fmt

    #wine # for ida.exe of IDA 6.8 (IDA 7.0 etc dont work)
    #winePackages.unstableFull
    # https://nixos.wiki/wiki/Wine
    #wineWowPackages.stable
    #wineWowPackages.staging
    wineWowPackages.unstableFull
    /*
    wine64Packages.unstableFull
    winetricks
    dosbox # DOS emulation for old apps like nmake15.exe
    */

    #github-desktop # useless, just a git client, no editor

    /*
    qt6.qttools # designer
    qt6.qttools.dev # designer
    */

    patchelf

    # nix run github:nix-community/nix-init -- --help
    nix-init


    python3.pkgs.memory_profiler # mprof

    bc # calculator

    bbe # binary sed

    sqlite

    #virtualbox
    #virt-manager

    #gnuplot

    geoipWithDatabase
    #filezilla # FTP client

    #kcharselect # KDE unicode character search

    # partition, format, filesystem
    gparted
    btrfs-progs
    xfsprogs
    exfatprogs

    # compressed filesystems
    /*
    erofs-utils
    squashfs-tools-ng
    */

    # FIXME: system-path> warning: collision between `/nix/store/cjipx2k0c4aba4x9802w9vg2yjym624w-exfatprogs-1.2.1/sbin/fsck.exfat' and `/nix/store/vjyzyl43qbxkg7z8srg5d251nhawqa84-exfat->
    exfat
    #exfatprogs


    mlocate # mlocate, updatedb # find files in a filesystem with a cached database

    nur.repos.milahu.tap-bpm-cli # get tempo of music

    #nur.repos.milahu.gh2md # export github issues to markdown


    rsync
    rclone
    fpart # fpsync: parallel rsync

    sshpass # pass password to non-interactive ssh client
    # needed for web.sourceforge.net

    # get multiple hashes of a file
    rhash # tiger-hash
    #hashdeep
    #hashrat # no. this runs only one hash function
    # TODO more
    # https://unix.stackexchange.com/questions/163747/simultaneously-calculate-multiple-digests-md5-sha256

    #archivemount
    #nur.repos.arti5an.mount-zip
    #nur.repos.milahu.fuse-zip # TODO

    # desktop automation. control desktops, windows, mouse, keyboard
    /*
    xdotool
    wmctrl
    */

    #libnotify # notify-send: send notifications from bash script to desktop

    # FIXME python3.11-libretranslate> substitute(): ERROR: file 'requirements.txt' does not exist
    #libretranslate
    python3Packages.argostranslate
    #python3Packages.translatehtml

    # fix: man 3 crypt
    # via: man 5 shadow
    man-pages

    openssl
    nss.tools # certutil to add certs to $HOME/.pki


    #nano-wallet # nanocoin, nanocurrency
    #nur.repos.milahu.nano-node # FIXME build
    monero-gui
    # TODO haveno

    # seq 10 | datamash sum 1
    # seq 100000000 | datamash  --format '%.0f' sum 1
    # seq 10 | datamash mean 1 # mean == average
    # https://stackoverflow.com/a/55392673/10440128
    datamash # math. sum. average

    # email
    #notmuch # offline email manager. search, tag, ... emails are stored in maildir
    #lieer # sync emails with gmail. alternative to offlineimap, isync, ...
    #mb2md # convert mbox to maildir
    #nur.repos.milahu.python3.pkgs.netviel # webinterface for notmuch

    gnumake # many builds are based on makefiles: native node modules, ...

    pkg-config # required by some build tools

    #cling # c repl / c shell

    nur.repos.milahu.qaac # high-quality aac encoder

    # nur.repos.milahu.mpv-downmix-gui # FIXME build

    nur.repos.milahu.fritzbox-reconnect

    # reverse engineering
    # nix-shell -E 'with import <nixpkgs> {}; (cutter.withPlugins (p: with p; [ jsdec rz-ghidra sigdb ]))'
    #(cutter.withPlugins (p: with p; [ jsdec rz-ghidra sigdb ]))

    simplescreenrecorder # too complex? maybe find something more simple

    shellcheck # check bash scripts


    # edit tags of multimedia files: audio, video
    tageditor
    libsndfile
    id3v2
    /*
    python3.pkgs.eyed3
    id3lib
    python3.pkgs.mutagen
    */

    dos2unix

    keepassxc # password manager

    # TODO update nixpkgs
    # quodlibet

    #torrenttools

    #nur.repos.milahu.spotify-adblock # FIXME rust build

    gnupg # gpg
    pinentry-qt

  ];
}

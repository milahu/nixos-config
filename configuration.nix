# TODO disable tor hidden service. waste of cpu time

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

  # override nixos modules
  # https://stackoverflow.com/a/46407944/10440128
  disabledModules = [
    #"services/security/tor.nix"
    # prometheus-qbittorrent-exporter
    #"services/monitoring/prometheus/default.nix"
    "services/monitoring/prometheus/exporters.nix"
  ];

  imports = [

    ./hardware-configuration.nix

    ./cachix.nix # cachix use nix-community

    #./modules/services/networking/pure-ftpd.nix # poor config

    # override nixos module services/security/tor.nix
    #./modules/services/security/tor.nix

    #./modules/services/networking/proftpd.nix
    #/home/user/src/nixos/milahu--nixos-packages/nur-packages/modules/services/networking/proftpd.nix

    ./modules/services/networking/ngrok.nix

    # prometheus-qbittorrent-exporter
    #/home/user/src/nixpkgs/nixos/modules/services/monitoring/prometheus/default.nix
    /home/user/src/nixpkgs/nixos/modules/services/monitoring/prometheus/exporters.nix
    # TODO? this would require lots of copy-paste from nixpkgs to nur.repos.milahu
    # pkgs.nur.repos.milahu.modules.prometheus-exporters

  ];

  nixpkgs.overlays = [

    (pkgz: pkgs: {
/*
      #proftpd = pkgs.callPackage ./pkgs/proftpd/proftpd.nix { };
      proftpd = pkgs.callPackage /home/user/src/nixos/milahu--nixos-packages/nur-packages/pkgs/proftpd/proftpd.nix { };
*/

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
  # automatic garbage collection in /nix/store
  # useful on small hard drives
  /*
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  */

  # Override select packages to use the unstable channel
  # no effect
  /*
  # usage:
  #   nur.repos.mic92.hello-nur
  #   nur.repos.milahu.brother-hll5100dn
  # nur-packages
  nixpkgs.config.packageOverrides = pkgs: {
    #nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    nur = import (inputs.nur) {
      inherit pkgs;
      repoOverrides = {
        milahu = import /home/milahu/src/milahu/nur-packages { inherit pkgs; };
        # mic92 = import (builtins.fetchTarball "https://github.com/your-user/nur-packages/archive/master.tar.gz") { inherit pkgs; };
      };
    };
  };
  */

  # dont build nixos-manual-html (etc)
  documentation.doc.enable = false;
  documentation.nixos.enable = false;

  # TODO open port 22 in firewall
  #services.sshd.enable = true;
  # https://nixos.wiki/wiki/SSH_public_key_authentication
  services.openssh = {
    enable = true;
    settings =
    #if true then { } else # INSECURE
    {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };

  /*
  # effects for pulseaudio
  services.easyeffects = {
    enable = true;
    #preset = "";
  };
  */

  # Enable ngrok client
  # ngrok = port forwarding
  services.ngrok = {
    #enable = true;
    configFile = "/home/user/.config/ngrok/ngrok.yml";
    user = "user";
    group = "users";
  };

  # jackett = torrent search
  # http://127.0.0.1:9117/
  services.jackett = {
    #enable = true;
    #openFirewall = true;
    # risky: this gives jackett access to home folder
    #user = "user";
    #group = "users";
    #dataDir = "/home/user/.config/Jackett";
  };

  # FIXME this hangs at "paperless migrate"
  # with existing /var/lib/paperless/
  # scan manager
  # https://discourse.nixos.org/t/someone-successfully-running-paperless-ngx/20511
  services.paperless = {
    #enable = true;
    address = "0.0.0.0";
    port = 58080; # http://localhost:58080/
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_ADMIN_PASSWORD = "admin";
    };
    passwordFile = "/run/keys/paperless-password";
  };

  /*
  systemd.services.paperless-scheduler.after = ["var-lib-paperless.mount"];
  systemd.services.paperless-consumer.after = ["var-lib-paperless.mount"];
  systemd.services.paperless-web.after = ["var-lib-paperless.mount"];
  */

  # ipfs
  #services.kubo.enable = true;

  # testing. simpler: sqlite
  # nixpkgs/nixos/modules/services/databases/postgresql.nix
  # nixpkgs/pkgs/servers/sql/postgresql
  /*
  services.postgresql = {
    #enable = true;
    package = pkgs.postgresql;
    #extraPlugins = with pkgs.postgresql.pkgs; [ ];
    # map-name system-username database-username
    identMap = ''
      idmap1 user user
    '';
  };
  */

  # https://github.com/NixOS/nixpkgs/issues/245376#issuecomment-1651114676
  # TODO wait for https://github.com/NixOS/nixpkgs/pull/243050 libretranslate: init service
  # TODO https://github.com/NixOS/nixpkgs/issues/250863 Packaging request: Argos translation data as Nix packages
  # TODO https://github.com/NixOS/nixpkgs/issues/250854 Packaging request: Argos Translate GUI
  /*
  systemd.services.libretranslate = {
    description = "LibreTranslate service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      HOME = "/var/lib/libretranslate";
    };
    serviceConfig = {
      ExecStart = "${pkgs.libretranslate}/bin/libretranslate";
      DynamicUser = true;
      WorkingDirectory = "/var/lib/libretranslate";
      StateDirectory = "libretranslate";
    };
  };
  */

  /*
    # TODO use distcc to distribute ALL builds across multiple machines ("build farm")
    services.distccd = {
    enable = true;
    allowedClients = [ "127.0.0.1" "192.168.1.0/24" ];
    openFirewall = true;
    zeroconf = true;
    };
  */

  # no. too much information. too little gui config
  # moving to grafana + prometheus
  # https://github.com/netdata/netdata
  # https://nixos.wiki/wiki/Netdata
  # https://learn.netdata.cloud/docs/configuring/securing-netdata-agents/web-server

  # no. netdata is too heavy
  # instead, use vnstat
  #services.netdata.enable = true;
  # only listen on localhost
  # http://localhost:19999/
  services.netdata.configText = ''
    [web]
    default port = 19999
    bind to = 127.0.0.1=dashboard^SSL=optional
  '';

  # monitor network speed and traffic
  services.vnstat.enable = true;

  # https://nixos.wiki/wiki/Grafana
  # nixpkgs/nixos/modules/services/monitoring/grafana.nix
  # https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/
  # http://localhost:3000/
  # login: admin:admin
  services.grafana = {
    enable = true;
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-piechart-panel # for prometheus-qbittorrent-exporter
    ];
    settings = {
      analytics.reporting_enabled = true;
      users.viewers_can_edit = true;
      users.editors_can_admin = true;
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
        # Grafana needs to know on which domain and URL it's running
        domain = "localhost";
        #root_url = "http://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
      };
      # https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/#anonymous-authentication
      "auth.anonymous" = {
        enable = true;
        # Organization name that should be used for unauthenticated users
        org_name = "localhost";
        # Role for unauthenticated users, other valid values are `Editor` and `Admin`
        org_role = "Viewer";
      };
      "auth.basic" = {
        enabled = false;
      };
      auth = {
        # no. hangs at "Welcome to Grafana"
        #disable_login_form = true;
      };
    };
  };

  # https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/
  services.prometheus = {
    enable = true;
    port = 9001;
    # /var/lib/prometheus2/
    #retentionTime = "15d"; # default -> 80 MB
    retentionTime = "740d"; # 2 years -> 4 GB
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      qbittorrent = {
        enable = true;
        port = 9003;
        qbittorrentPort = 1952;
        package = pkgs.nur.repos.milahu.prometheus-qbittorrent-exporter;
      };
    };
    scrapeConfigs = [
      {
        job_name = "chrysalis";
        static_configs = [{
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            "127.0.0.1:${toString config.services.prometheus.exporters.qbittorrent.port}"
          ];
        }];
      }
    ];
  };

  # seed all derivations created by fetchtorrent
  # https://github.com/NixOS/nixpkgs/pull/212930#issuecomment-1771619750
  #  error: The option `services.seed-nixpkgs' does not exist. Definition values:
  #services.seed-nixpkgs.enable = true;

  networking.hostName = "laptop1";

  /* replaced with tigervnc
    nixpkgs.config.permittedInsecurePackages = [
    "tightvnc-1.3.10"
    ];
  */

  # my ISP (deutsche telekom) is censoring some websites via DNS. fuck censorship.
  # FIXME not used in /etc/resolv.conf. blame VPN?
  # TODO rotate DNS servers. see options in: man resolv.conf
  # TODO? DNS over TLS = DoT
  # sudo netselect -vv 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220 185.228.168.9 185.228.169.9  8.26.56.26 8.20.247.20
  # 
  networking.nameservers = [
    # cloudflare DNS
    "1.1.1.1"
    #"1.0.0.1"
    # 2x slower than cloudflare
    /*
    # google DNS
    "4.4.4.4"
    "8.8.4.4"
    */
  ];

# TODO add some domains to /etc/hosts
/*
https://github.com/ngosang/trackerslist/blob/master/trackers_all.txt
https://github.com/ngosang/trackerslist/blob/master/trackers_all_ip.txt
*/

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-12.22.12" # TODO who needs nodejs 12? pkgs.nodejs-12_x
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #"osu-lazer"
    #"flashplayer"
    #"vscode" # -> vscodium
    "rar"
    #"lzturbo"
    "unrar" # pyload
    "brgenml1lpr" # brother printer
    #"brother-hll3210cw" # brother printer
    # hll6400dwlpr-3.5.1-1
    #"brother-hll6400dw-lpr"
    "brother-hll5100dn-lpr"
    #"cups-kyocera-ecosys-m552x-p502x" # kyocera p5021cdn printer
    #"cnijfilter2" # canon printer: cnijfilter2-6.10
    "font-bh-lucidatypewriter-75dpi" # https://github.com/NixOS/nixpkgs/issues/99014
    #"Oracle_VM_VirtualBox_Extension_Pack"
    "ngrok"
    "brscan4"
    "brscan5"
    "brother-udev-rule-type1"
    "brscan4-etc-files"
    "brscan5-etc-files"
    "qaac-unwrapped"
    "selenium-driverless"
    "spotify"
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

  #nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  #nix.extraOptions = ''
  #       builders-use-substitutes = true
  #'';

# https://input-output-hk.github.io/haskell.nix/tutorials/getting-started
/*
# Binary Cache for Haskell.nix  
nix.binaryCachePublicKeys = [
  "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
];
nix.binaryCaches = [
  "https://cache.iog.io"
];
*/

  networking.extraHosts =
    ''
      192.168.178.21 laptop1
      192.168.178.20 laptop2
      #73.157.50.82 jonringer
    '';

  /*
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nixos/nixos-cache/cache-priv-key.pem";
    # /etc/nixos/nixos-cache/cache-pub-key.pem
  };
  */

  # no. this is defined in /etc/nixos/hardware-configuration.nix
  #fileSystems."/" = ...



  # NFS
  # network filesystems
  # https://nixos.wiki/wiki/NFS
  # TODO more dynamic. export all /run/media/user

  /*
    $ ls /run/media/user/* -d | cat
    /run/media/user/achttera1
    /run/media/user/fourtera
    /run/media/user/fourtera3
    /run/media/user/Usb16
  */

  fileSystems."/export/achttera1" = {
    device = "/run/media/user/achttera1";
    options = [ "bind" ];
  };

  fileSystems."/export/fourtera" = {
    device = "/run/media/user/fourtera";
    options = [ "bind" ];
  };

  fileSystems."/export/fourtera3" = {
    device = "/run/media/user/fourtera3";
    options = [ "bind" ];
  };

  fileSystems."/export/twotera1/torrent" = {
    device = "/home/user/down/torrent/done";
    options = [ "bind" ];
  };

  # permission denied...
  /*
  fileSystems."/export/run-media-user" = {
    device = "/run/media/user";
    options = [ "bind" ];
  };
  */

  /*
    /export                 192.168.178.20(ro,no_subtree_check,fsid=0)
    /export/run-media-user  192.168.178.20(ro,no_subtree_check,nohide,insecure)

    /export                 192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check)
    /export/run-media-user  192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check)

    /export/run-media-user  192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,nohide,insecure)
  */
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export                 192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,fsid=0)
    /export/achttera1       192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,nohide,insecure)
    /export/fourtera        192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,nohide,insecure)
    /export/fourtera3       192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,nohide,insecure)
    /export/twotera1        192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,fsid=0)
    /export/twotera1/torrent        192.168.178.20(ro,all_squash,anonuid=1000,anongid=100,no_subtree_check,sec=sys,nohide,insecure)
  '';
  #networking.firewall.allowedTCPPorts = [ 2049 ];

  programs.extra-container.enable = true; # nixos unstable

  # gnome-terminal requires a systemd service
  programs.gnome-terminal.enable = true;

  # sudo sysctl net.core.rmem_max=4194304 net.core.wmem_max=1048576
  boot.kernel.sysctl."net.core.rmem_max" = 4194304; # transmission-daemon told me to = 10x more than 425984
  boot.kernel.sysctl."net.core.wmem_max" = 1048576;

  # TODO /home/user/todo/nixos-darkmode.txt
  boot.loader.grub.gfxmodeEfi = "text";
  boot.loader.grub.gfxmodeBios = "text";

  # TODO better?
  # "sudo mount" works, but mounting as user fails (via kde plasma desktop) with error:
  # wrong fs type, bad option, bad superblock missing codepage or helper program
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2; # warning: The boot.loader.grub.version option does not have any effect anymore
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  #boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

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
  #networking.firewall.checkReversePath = false; # disable rpfilter for wg-quick

  /*
  https://old.reddit.com/r/NixOS/comments/121rs17/does_anyone_know_how_to_remove/

  > Does anyone know how to remove systemd-journal-flush.service? It's making my boot on NixOS very slow.

  You can set logging to volatile instead of persistent and limit the max size of the journal. that will speed it up.

  but you won't have logs from previous boots anymore. on a desktop not a huge problem but maybe not so good for an important server.

  thjat said: i never had problems with that service. i only do this because i really dont need logs to fill my disk.

  I use: services.journald.extraConfig = '' Storage=volatile RateLimitInterval=30s RateLimitBurst=10000 RuntimeMaxUse=16M SystemMaxUse==16M '';
  */
  /*
    Storage=volatile
    RateLimitInterval=30s
    RateLimitBurst=10000
    RuntimeMaxUse=16M
  */
  # limit size of /var/log/journal
  # journalctl --vacuum-size=20M
  services.journald.extraConfig = ''
    SystemMaxUse=20M
  '';

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    # TODO print layout + time format
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

  # FIXME networkmanager breaks br0 for container networking
  networking.networkmanager.enable = true;
  # https://nlewo.github.io/nixos-manual-sphinx/configuration/network-manager.xml.html
  # https://developer-old.gnome.org/NetworkManager/stable/NetworkManager.conf.html#device-spec
  # networking.networkmanager.unmanaged  = [ "*" "except:type:wwan" "except:type:gsm" ]; # TODO why "*" ?!
  networking.networkmanager.unmanaged  = [
    # TODO move this to containers, avoid globbing
    "interface-name:br*" # br0
    "interface-name:ve-*" # ve-milahuuuc365
    "interface-name:vb-*" # vb-milahuuuc365
    # TODO move this to docker, avoid globbing
    "interface-name:docker*" # docker0
  ];

  # bypass networking.networkmanager
  #networking.defaultGateway = "192.168.178.1";

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
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.options  = "eurosign:e";
  services.xserver.videoDrivers = [ "intel" ];
  #services.xserver.useGlamor = true; # TODO?

  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "user";



  # === KDE SDDM ===
  # kde login
  #services.xserver.displayManager.sddm.enable = true;
  services.displayManager.sddm.enable = true;

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



  /*
  # gnome login
  # broken: display-manager.service hangs at "starting X11 server..."
  services.xserver.displayManager.gdm.enable = true;

  # gnome desktop
  # gnome is still gay.
  # gnome is still SHIT. gnome-shell still has a memory leak -> needs 2.6 GByte RAM after some days of uptime
  # cannot scale display to 150% (only 100% or 200%)
  # terminal is gay (cannot rename tabs)
  # -> back to kde
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    ]) ++ (with pkgs.gnome; [
    cheese # screenshot tool
    gnome-music
    #gnome-terminal
    #gedit
    epiphany
    #evince
    #gnome-characters
    totem # video player
    geary
    # games?
    tali
    iagno
    hitori
    atomix
  ]);

  # gnome
  # fix:  dconf-WARNING **: failed to commit changes to dconf: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name ca.desrt.dconf was not provided by any .service files
  programs.dconf.enable = true;

  # gnome
  services.udev.packages = with pkgs; [
    gnome3.gnome-settings-daemon
  ];
  */



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
  # 127.0.0.1:9050 # SocksPort
  # 127.0.0.1:9051 # ControlPort
  # 127.0.0.1:9053 # DNSPort
  services.tor = {
    #services.tor.enable = true; # slow (but secure) socks proxy on port 9050: one circuit per destination address
    enable = true;
    client = {
      #services.tor.client.enable = false; # needed for insecure services
      #services.tor.client.enable = true; # fast (but risky) socks proxy on port 9063 for https: new circuit every 10 minutes
      enable = true;

      # this will add:
      # settings.DNSPort = [{ addr = "127.0.0.1"; port = 9053; }];
      # settings.AutomapHostsOnResolve = true;
      dns.enable = true;
    };

    # disable by-country statistics
    enableGeoIP = false;

    # FIXME enable tor relay
    # TODO open port in router
    openFirewall = true;
    # [warn] Tor is currently configured as a relay and a hidden service.
    # That's not very secure: you should probably run your hidden service in a separate Tor process, at least
    # https://bugs.torproject.org/tpo/core/tor/8742

    settings.ControlPort = 9051;

    /*
    relay = {
      enable = true;
      role = "relay";
      #role = "bridge"; # exit node?
    };
    settings = {
      ContactInfo = "milahu@gmail.com";
      Nickname = "milahu";
      # no. port 9001 is taken by services.prometheus
      #ORPort = 9001;
      #ORPort = 9002;
      #ControlPort = 9051;
      # max: 40 Mbit = 5 MByte
      BandWidthRate = "1 MBytes";
    };
    */
  };

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

  #services.tor.hideWarningSeparateTorProcess = true;



  # no. waste of cpu and network
  # i2p
  # https://mdleom.com/blog/2020/03/21/i2p-eepsite-nixos/
  services.i2pd = {
    #enable = true;
    notransit = true; # ?
    # port (TCP & UDP) port to listen for incoming connection. Even though i2pd supports NAT traversal, it’s not reliable in my experience. This port needs to be open or port-forwarded. Choose any random port between 1024-65535.
    # TCP & UDP
    port = 9898;
    # TCP
    # ntcp2.port (TCP) port to listen for incoming NTCP2 connection. Choose any random port between 1024-65535. This port also needs to be open.
    #ntcp2.port = 9899;
    enableIPv4 = true;
    enableIPv6 = true;
  };



  # container for tor hidden services
  # https://nixos.wiki/wiki/NixOS_Containers
  # TODO use one tor hidden service
  # for multiple services on different ports
  # https://github.com/onionshare/onionshare/issues/27
  # ricochet?
  # TODO gitea pages / codeberg pages
  # TODO caddy? CI/CD job runner for gitea
  # https://msucharski.eu/posts/application-isolation-nixos-containers/
  # TODO? move to containers/*.nix

  # TODO? use cgit instead of gitea
  # https://git.causal.agency/cgit-pink/about/
  # via https://spectrum-os.org/git/spectrum/
  # https://spectrum-os.org/doc/ # security by compartmentalization

  # https://discourse.nixos.org/t/nixos-containers-how-to-allow-internet-access-but-isolate-containers/8613/4

  # https://nixos.wiki/wiki/Tor_Browser_in_a_Container

  /*
    transparent tor proxy

    https://csmarosi.github.io/tor-in-docker.html

      The container sets some iptables rules after start; at least the following is needed:

      iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
      iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
      iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT
      iptables -A OUTPUT -d 127.0.0.0/8 -j ACCEPT
      iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
      iptables -A OUTPUT -j REJECT

    https://gitlab.torproject.org/legacy/trac/-/wikis/doc/TransparentProxy

    https://linuxsecurity.com/features/how-to-create-a-transparent-proxy-through-the-tor-network-to-protect-your-privacy-online-with-archtorify-kalitorify
    https://github.com/brainfucksec/archtorify

    https://github.com/torservers/onionize-docker
    One caveat for this method is that it will only work for services that do not need to connect out to the internet, in an anonymized fashion or otherwise.
    If you're running a service that needs access to the internet, you'll need to either configure your service so that it proxies its connection over Tor, or you can look into some experimental work on a custom Tor network driver for Docker.

    https://tor.stackexchange.com/questions/4035/how-does-tor-transparent-proxying-work

    https://andreafortuna.org/2019/06/19/tor-transparent-proxy-on-linux-a-simple-implementation/

    https://unix.stackexchange.com/questions/548886/how-to-enable-internet-access-for-nixos-container-with-private-network
    the container has no external access to the internet. How can I enable external access?
    iptables -t nat -A POSTROUTING -o wlp2s0f0u7 -j MASQUERADE
    networking.nat.externalInterface = "wlp2s0f0u8";
  */

  /*
  # enable port forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
  */

  # give internet access to containers with privateNetwork = true
  networking.nat = {
    enable = true;
    internalInterfaces = [
      # actual device name is ve-somecontXXXX with random suffix "XXXX" -- TODO why?!
      #"ve-somecont*" # note: "*" glob star is wrong here
      "ve-somecont+"
      "ve-milahuuuc365" # here no random suffix is added
    ];
    externalInterface = "enp0s25"; # TODO what? # TODO get dynamic name of eth0
    # Lazy IPv6 connectivity for the container
    #enableIPv6 = true;

    # working: http://10.10.100.20:8100/
    /*
    forwardPorts = [
      # not working
      {destination = "10.10.100.10:8100"; sourcePort = 8100;} # no # hostAddress = "10.10.100.10";
      # not working
      {destination = "10.10.100.20:8100"; sourcePort = 8366;} # no # localAddress = "10.10.100.20";
    ];
    */

    # iptables -t nat -A nixos-nat-post -d ${container.localAdress} --dport 80 -j SNAT --to-source ${container.hostAdress}
    # iptables -t nat -A nixos-nat-post -d 10.10.100.20 --dport 80 -j SNAT --to-source 10.10.100.10
    # iptables -t nat -A nixos-nat-post -d 10.10.100.20 --dport 8100 -j SNAT --to-source 10.10.100.10
    # unknown option "--dport"
    extraCommands = ''
    '';
  };

  # TODO for better security use trustix
  # https://github.com/nix-community/trustix
  # https://www.tweag.io/blog/2020-12-16-trustix-announcement/
  # machinectl shell root@milahuuuc365
  #containers."milahuuuc365" = rec {
  containers = if true then {} else { # disable container

    autoStart = true;

    # https://nixos.wiki/wiki/NixOS_Containers
    # when privateNetwork is set to true,
    # the container gains its private virtual eth0 and ve-<container_name> on the host.
    # This isolation is beneficial when you want the container to have its dedicated networking stack
    # NOTE this offers no security / isolation
    # this only creates a separate virtual network interface
    # this is useful to run multiple services using the same port
    privateNetwork = true;

    # https://en.wikipedia.org/wiki/Private_network
    # using 192.168.xxx.xxx feels wrong...
    # hostAddress = "192.168.100.10";
    # localAddress = "192.168.100.11";

    # either hostBridge OR hostAddress, but not both?
    # no
    # this is not working. just leave it unset, then it works
    # FIXME Failed to add interface vb-milahuuuc365 to bridge br0: No such device
    # Put the host-side of the veth-pair into the named bridge.
    # Only one of hostAddress* or hostBridge can be given.
    #hostBridge = "br0"; # containerBridge

    # # ip route 
    # default via 10.10.100.10 dev eth0 
    #10.10.100.10 dev eth0 scope link 
    # ve-somecontainer interface on the host side
    hostAddress = "10.10.100.10";
    #hostAddress6 = "fc00::1";

    # # ip a s 
    # 2: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    #     link/ether 02:96:66:58:67:e5 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    #     inet 10.10.100.15/32 scope global eth0
    #localAddress = "10.10.100.15";
    #hostAddress = "10.10.100.10";
    localAddress = "10.10.100.20";
    #localAddress = "${containerAddress}/24";
    #localAddress6 = "fc00::2";

    # TODO internal device name?
    # needed for tor.client.transparentProxy.asdf

    config = { config, pkgs, ... }:
    let
      patchedPackages = rec {
        curl = (pkgs.curl.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or []) ++ [
            # add support for CURL_ALLOW_DOT_ONION=1
            # fix: I want to resolve onion addresses
            # https://github.com/curl/curl/discussions/11125
            # https://github.com/curl/curl/pull/11236
            (pkgs.fetchurl {
              url = "https://github.com/curl/curl/pull/11236.patch";
              sha256 = "sha256-7UMLiUJEZglACu5oF4A5CTKbFyJptmpulYGJmIgP/Wc=";
            })
          ];
        }));
        git = (pkgs.git.override {
          inherit curl;
        });

        # patchedPackages.gitea
        gitea = (pkgs.gitea.overrideAttrs (oldAttrs: rec {
          # gitea> buildPhase completed in 25 minutes 17 seconds
          # gitea> checkPhase completed in 17 minutes 26 seconds
          doCheck = false; # waste of time
          # FIXME build from source
          /*
          version = "1.21.6"; # 2024-02-22
          src = pkgs.fetchFromGitHub {
            # https://github.com/go-gitea/gitea
            owner = "go-gitea";
            repo = "gitea";
            rev = "v${version}";
            hash = "sha256-eWObhCeIqbhKMX4BSVJXWeY8obCSyXKk3m1UXv+9bxE=";
          };
          */
          # https://github.com/go-gitea/gitea/pull/28909
          # Respect branch info for relative links
          version = "1.21.6"; # 2024-02-22
          # FIXME build from source
          # not fetching directly from the git repo, because that lacks several vendor files for the web UI
          #src = fetchurl {
          src = pkgs.fetchurl {
            url = "https://dl.gitea.com/gitea/${version}/gitea-src-${version}.tar.gz";
            hash = "sha256-tixWipiVHugacTzBurdgfiLnKyVDDcqCPlysj2DoWjg=";
          };
          # also patch version
          # https://github.com/milahu/nixpkgs/issues/34
          # stdenv.mkDerivation: overrideAttrs fails to override derived attributes
          ldflags = [
            "-s"
            "-w"
            "-X main.Version=${version}"
            "-X 'main.Tags=${lib.concatStringsSep " " oldAttrs.tags}'"
          ];
          patches = (oldAttrs.patches or []) ++ [
            # https://github.com/go-gitea/gitea/pull/29427
            # Use relative links
            (pkgs.fetchurl {
              url = "https://github.com/go-gitea/gitea/pull/29427/commits/db9e75817c5fce7da21dad61f05e41d5119834ba.patch";
              hash = "sha256-bZULwXcfaqzTKvbIwftOdyLvdhYzX4ZqkjfMdYeXrhY=";
            })
          ];
        })).override {
          inherit git;
        };

      }; # end of patchedPackages

      # cat /dev/random | base64 -w0 | head -c100
      meilisearchMasterKey = "AUCh0ZkV4LilZiY9yHLvuxiW2q2FqFAhjyTlIpGxjPJ4WPHe4p411ROM7gHNt0P5wOOt7mnWH2jhDW6OQg8HnPfE4MDw0wYOk9Oz";

    in
    rec {

      networking.enableIPv6 = false;

      /*
       error: The option `containers.milahuuuc365.networking.useDHCP' has conflicting definition values:
       - In `/nix/store/qj4mpzbis3syryphw71ywc8av4hhzp6y-source/nixos/modules/virtualisation/nixos-containers.nix': true
       - In `module at /nix/store/qj4mpzbis3syryphw71ywc8av4hhzp6y-source/nixos/modules/virtualisation/nixos-containers.nix:489': false
      */
      #networking.useDHCP = true;

      # override nixos modules
      # https://stackoverflow.com/a/46407944/10440128
      disabledModules = [
        # override nixos module services/security/tor.nix
        "services/security/tor.nix"
      ];

      imports = [
        # override nixos module services/security/tor.nix
        ./modules/services/security/tor.nix
      ];

      # TODO what is containerGateway
      #networking.defaultGateway = containerGateway;
      #networking.defaultGateway = hostAddress;

      #networking.nameservers = [ hostAddress ];

      # limit size of /var/log/journal
      # journalctl --vacuum-size=20M
      services.journald.extraConfig = ''
        SystemMaxUse=20M
      '';

      # https://nixos.wiki/wiki/Firewall
      networking.firewall = {
        allowedTCPPorts = [
          # working: http://10.10.100.20:8100/
          # no?! not needed
          #8100 # gitea
        ];
        #enable = true; # todo restore for transparent tor proxy
        #enable = false; # test internet connection
        /*
        allowedTCPPorts = [ 80 443 ];
        allowedUDPPortRanges = [
          { from = 4000; to = 4007; }
          { from = 8000; to = 8010; }
        ];
        */
        # no. moved to ./modules/services/security/tor.nix
        /*
        extraCommands = ''
          iptables -t nat -A OUTPUT -m owner --uid-owner ${user.tor.uid} -j RETURN
          iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
          iptables -A OUTPUT -m owner --uid-owner ${user.tor.uid} -j ACCEPT
          iptables -A OUTPUT -d 127.0.0.0/8 -j ACCEPT
          iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
          iptables -A OUTPUT -j REJECT
        '';
        */
        # no. enp0s25 is not visible inside the container
        /*
        extraCommands = ''
          iptables -t nat -A POSTROUTING -o enp0s25 -j MASQUERADE
        '';
        */
      };

      /*

      https://gitlab.torproject.org/legacy/trac/-/wikis/doc/TransparentProxy

      # Tor's TransPort
      _trans_port="9040"

      # Tor's VirtualAddrNetworkIPv4
      _virt_addr="10.192.0.0/10"

      # nat .onion addresses
      iptables -t nat -A OUTPUT -d $_virt_addr -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports $_trans_port

      # Redirect all other pre-routing and output to Tor's TransPort
      iptables -t nat -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports $_trans_port

      # Your outgoing interface
      _out_if="eth0"

      */

      # TODO use nftables instead of iptables
      # nftables tor transport transparent tor proxy
      /*
        https://hev.cc/posts/2021/transparent-proxy-with-nftables/
        https://github.com/heiher/hev-socks5-tproxy
        https://github.com/szorfein/paranoid-ninja
        https://francis.begyn.be/blog/nixos-home-router
        https://scvalex.net/posts/54/
      */
      /*
      networking.firewall = {
        enable = true;
      };
      networking.nftables = {
        enable = true;
        # ...
      };
      */

      # test
      # todo rmeove
      networking.nftables = {
        #enable = true;
        # ...
      };

      /*
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud28;
        hostName = "localhost";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
      };
      */

      system.stateVersion = "23.11";

      # above
      /*
      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = mkForce false;
      };
      */
      
      # TODO what
      # error: Using host resolv.conf is not supported with systemd-resolved
      #services.resolved.enable = true;

      environment.variables = {
        # fix: curl: Not resolving .onion address (RFC 7686)
        CURL_ALLOW_DOT_ONION = "1";
      };

      # FIXME this also overrides nixpkgs of the host machine
      /*
      nixpkgs.config.packageOverrides = pkgs: {
        # https://github.com/milahu/nixpkgs/issues/33
        # fix: curl: Not resolving .onion address (RFC 7686)
        curl = (pkgs.curl.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or []) ++ [
            # add support for CURL_ALLOW_DOT_ONION=1
            # fix: I want to resolve onion addresses
            # https://github.com/curl/curl/discussions/11125
            # https://github.com/curl/curl/pull/11236
            (pkgs.fetchurl {
              url = "https://github.com/curl/curl/pull/11236.patch";
              sha256 = "sha256-7UMLiUJEZglACu5oF4A5CTKbFyJptmpulYGJmIgP/Wc=";
            })
          ];
        }));
      };
      */

      environment.systemPackages =
      (with patchedPackages; [
        curl
        git
        #gitea
        #cgit-pink
      ])
      ++
      (with pkgs; [
        #virt-manager
        iptables # debug: iptables -L -v -t nat
        #git
        #curl
        wget # TODO resolve onion
        nano
        jq
        yaml2json
        dig # dns client. dig +trace example.com
        netselect # sort servers by latency

        # python for /var/lib/containers/milahuuuc365/var/lib/lighttpd/www/bin/get-subtitles
        (python3.withPackages (p: with p; [
            # get-subtitles
            guessit # parse video filenames
            platformdirs
            charset-normalizer
            #inputs.nur.repos.milahu.python3.pkgs.stream-zip
            #pkgs.nur.repos.milahu.python3.pkgs.stream-zip
            #inputs.nur-packages-milahu.pkgs.python3.pkgs.stream-zip
            # wtf?!
            (python3.pkgs.callPackage /home/user/src/milahu/nur-packages/pkgs/python3/pkgs/stream-zip/stream-zip.nix {})

            # guestbook
            captcha
            psycopg2 # postgresql
            multipart # post data parser
        ]))

        # https://github.com/NixOS/nixpkgs/pull/226303
        # TODO rename package from codeberg-pages to codeberg-pages-server
        # TODO rename binary from pages to pages-server
        # laurent.nixpkgs@fainsin.bzh
        # https://github.com/Laurent2916
        # TODO add nixos service
        # no. this requires https but i only want a stupid http server -> lighttpd or nginx
        #codeberg-pages
      ]);

      # TODO? https://sqlite.org/althttpd/doc/trunk/althttpd.md

      # nixpkgs has only lighttpd version 1
      # https://git.lighttpd.net/lighttpd/lighttpd1.4/src/branch/master/doc/config/lighttpd.conf
      # lighttpd version 2 is unstable
      # https://redmine.lighttpd.net/projects/lighttpd2/wiki
      services.lighttpd =
      let
        #basedir = "/var/lib/lighttpd";
        lighttpd_home_dir = "/var/lib/lighttpd";
      in
      {
        enable = true;
        # Document-root of the web server. Must be readable by the "lighttpd" user.
        # TODO continuous integration. rsync? git clone?
        document-root = lighttpd_home_dir + "/www";
        #port = 8200;
        port = 80;
        #enableUpstreamMimeTypes = false;
        enableModules = [
          #"mod_deflate"
          "mod_status"
          "mod_cgi"
          "mod_access"
          "mod_accesslog"
          "mod_proxy"
          #"mod_limit"
          # TODO rate limiting
        ];
        # some modules are always enabled: mod_indexfile mod_dirlisting mod_staticfile
        # https://git.lighttpd.net/lighttpd/lighttpd1.4/src/branch/master/doc/outdated/dirlisting.txt
        extraConfig = ''

          var.home_dir    = "${lighttpd_home_dir}"
          #var.log_root    = "/var/log/lighttpd"
          #var.server_root = "/srv/www"
          #var.state_dir   = "/run"
          #var.conf_dir    = "/etc/lighttpd"
          #server.document-root = server_root + "/htdocs"
          #server.errorlog             = log_root + "/error.log"
          #server.errorlog = home_dir + "/error.log"
          #server.upload-dirs = ( "/var/tmp" )
          server.upload-dirs = ( home_dir + "/uploads" )

          # needed for logrotate
          #server.pid-file = state_dir + "/lighttpd.pid"
          #server.pid-file = "/var/run/lighttpd.pid"

          # the nixos lighttpd module does not expose this option
          # and adding "disable" does not work:
          #   accesslog.use-syslog = "disable"
          # nixos/modules/services/web-servers/lighttpd/default.nix
          # accesslog.use-syslog = "enable"
          # server.errorlog-use-syslog = "enable"

        	# mod_accesslog
        	# TODO logrotate
        	# 
        	#accesslog.filename = home_dir + "/access.log"
        	#accesslog.format = "%h %l %u %t \"%r\" %b %>s \"%{User-Agent}i\" \"%{Referer}i\""
        	#accesslog.use-syslog = "enable"

          # mod_status
          status.status-url          = "/server-status"
          status.config-url          = "/server-config"
          status.statistics-url      = "/server-statistics"

          # main resource limit is the number of file descriptors
          #server.max-fds = 1024
        	server.max-fds = 20

        	# size of the listen() backlog queue
        	#server.listen-backlog = 1024
        	#server.listen-backlog = 2
        	server.listen-backlog = 10

        	# error: sockets disabled, connection limit reached
        	#server.max-connections = 1024
        	#server.max-connections = 2
        	server.max-connections = 10

        	# Uploads to your server cant be larger than this value.
        	#server.max-request-size = 0
        	server.max-request-size = 5000

          # Time to read from a socket before we consider it idle.
          #server.max-read-idle = 60
          server.max-read-idle = 30

          # Time to write to a socket before we consider it idle.
          #server.max-write-idle = 360
          server.max-write-idle = 180

          dir-listing.activate = "enable"

          # TODO what?
          url.access-deny = ( "~", ".inc" )

          #static-file.exclude-extensions = ( ".php", ".pl", ".fcgi" )

          # https://git.lighttpd.net/lighttpd/lighttpd1.4/src/branch/master/doc/config/conf.d/cgi.conf
          #alias.url += ( "/bin" => basedir + "/bin" )
          cgi.execute-x-only = "enable"
          $HTTP["url"] =~ "^/bin/" {
            cgi.assign = ("" => "")
          }

          # buffer responses and send them in one part with "Content-Length: 12345" header
          #server.stream-response-body = 0
          # stream responses from the backend CGI with "Transfer-Encoding: chunked" header
          server.stream-response-body = 1
          # perform minimal buffering and potentially block the backend producer
          # if the client or network is slower than the producer
          #server.stream-response-body = 2

          # TODO show all text files as text/plain: html, js, css
          $HTTP["url"] =~ "^/src/" {
              mimetype.assign = (
                  ".html" => "text/plain",
                  ".md" => "text/plain",
                  ".css" => "text/plain",
                  ".js" => "text/plain",
                  ".py" => "text/plain",
                  ".c" => "text/plain",
                  ".cc" => "text/plain",
                  ".cpp" => "text/plain",
                  ".cxx" => "text/plain",
                  ".php" => "text/plain",
              )
          }

          # gitea
          # no. gitea only works at root
          #proxy.server = ("/src" => ( "" => ( "host" => "127.0.0.1", "port" => 8100 )))
          $HTTP["host"] =~ "^git\." {
            #alias.url = ( "/system/" => "/var/www/system/" )
            proxy.balance = "fair"
            proxy.server  = ( "" => ("" => ( "host" => "127.0.0.1", "port" => 8100)))
          }
        '';
      };

      # not needed. just let lighttpd log to syslog
      services.logrotate = {
        #enable = true;
        settings = {
          # global options
          header = {
            dateext = true;
          };
          # example custom files
          /*
          "/var/log/mylog.log" = {
            frequency = "daily";
            rotate = 3;
          };
          "multiple paths" = {
             files = [
              "/var/log/first*.log"
              "/var/log/second.log"
            ];
          };
          */
          # https://raw.githubusercontent.com/NixOS/nixpkgs/master/nixos/modules/services/web-servers/nginx/default.nix
          lighttpd = {
            #files = "/var/log/nginx/" + "*.log";
            files = "/var/lib/lighttpd/access.log";
            #frequency = "weekly";
            frequency = "daily";
            rotate = 10;
            compress = true;
            delaycompress = true;
            missingok = true;
            copytruncate = true;
            notifempty = true;
            #su = "${cfg.user} ${cfg.group}";
            #su = "${services.lighttpd.user} ${services.lighttpd.group}";
            su = "${builtins.toString config.ids.uids.lighttpd} ${builtins.toString config.ids.gids.lighttpd}";
            #postrotate = "[ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`";
            #serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
            postrotate = let p = "/var/run/lighttpd.pid"; in ''
              [ -f ${p} ] && ${pkgs.coreutils}/bin/kill -SIGUSR1 $(cat ${p})
            '';
          };
        };
      };

      # https://nixos.wiki/wiki/Tor
      services.tor = {
        # slow (but secure) socks proxy on port 9050: one circuit per destination address
        enable = true;

        client = {

          # fast (but risky) socks proxy on port 9063 for https: new circuit every 10 minutes
          enable = true;

          # this will add:
          # settings.TransPort = [{ addr = "127.0.0.1"; port = 9040; }]
          transparentProxy.enable = true;

          # TODO restore
          # TODO test
          /*
          curl -s https://check.torproject.org/api/ip
          */
          transparentProxy.routeAllTraffic = true;

          # patchedpackages.curl is wrong?
          # no. blame .curlrc

          #transparentProxy.externalInterface = "ve-milahuuuc365"; # TODO? via "ve-*"
          transparentProxy.externalInterface = "eth0"; # or eth0@if4
          #transparentProxy.externalInterface = "eth0@if4";

          # this will add:
          # settings.DNSPort = [{ addr = "127.0.0.1"; port = 9053; }];
          # settings.AutomapHostsOnResolve = true;
          dns.enable = true;

        };
        # disable by-country statistics
        enableGeoIP = false;
        #openFirewall = true;
        settings = {
          #ORPort = 9000;
        };
      };

      # https://gitea.com/curben/blog/src/branch/master/source/_posts/tor-hidden-onion-nixos.md
      services.tor.relay.onionServices = {
        # gitea server
        # keys are stored in /var/lib/tor/onion/milahuuuc365
        # milahuuuc3656fettsi3jjepqhhvnuml5hug3k7djtzlfe4dw6trivqd.onion
        "milahuuuc365" = {
          map = [
            /*
            { port = 80; target = { port = 8100; }; }
            { port = 2; target = { port = 8200; }; }
            */
            #{ port = 80; target = { port = 8200; }; } # lighttpd
            { port = 80; target = { port = 80; }; } # lighttpd
            #{ port = 22; target = { port = 22; }; } # ssh # TODO

            # TODO ssh + rsync
            #   TODO webinterface to create new ssh accounts = username + ssh public key
            #   TODO enable ssh only for rsync user
            #   TODO disable ssh login shell, allow only access via rsync
            #   TODO isolate rsync processes by ssh public key
            # TODO? onionshare https://github.com/onionshare/onionshare - too much?
          ];

          # FIXME implement this
          # no. run tor + gitea in a container
          #useSeparateTorProcess = true;

          # ... or default
          # useSeparateTorProcess = null;
          # and disable the warning with
          #useSeparateTorProcess = false;

          #version = 3;
          settings = {
            #TODO default in tor-insecure
            # FIXME this requires tor.client = false
            # https://github.com/NixOS/nixpkgs/pull/48625
            #HiddenServiceSingleHopMode = true; # NON ANONYMOUS. use tor only for NAT punching
            #HiddenServiceNonAnonymousMode = true; # TODO verify. use extraConfig?
            #SocksPort = 0;
            #HiddenServicePort = 80; # ?
          };
        };
        # no. use second port on milahuuuc365
        /*
        # static html server
        # keys are stored in /var/lib/tor/onion/milapage5kmd
        # TODO move to milahuweb...?
        "milapage5kmd" = {
          map = [
            { port = 80; target = { port = 8200; }; }
          ];
        };
        */
      };

      # https://ayats.org/blog/gitea-drone/
      # https://mcwhirter.com.au/craige/blog/2019/Deploying_Gitea_on_NixOS/
      services.postgresql = {
        # fix: error: postgresql_11 was removed, please upgrade your postgresql version.
        package = pkgs.postgresql_16;
        enable = true;

        ensureDatabases = [
          #config.services.gitea.user
          #config.services.lighttpd.user
          "lighttpd"
        ];
        ensureUsers = [
          {
            name = "lighttpd";
            ensureDBOwnership = true;
          }
        ];

        # By default, peer based authentication will be used for users connecting via the Unix socket
        # ???
        # error? Job for container@milahuuuc365.service failed because a timeout was exceeded.
        #authentication = pkgs.lib.mkOverride 10 ''
        authentication = ''
          #type database  DBuser    auth-method
          #local all       all       trust
          local lighttpd  lighttpd  trust
        '';

        # no. this is managed by services.gitea
        /*
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          { name = cfg.database.user;
            ensureDBOwnership = true;
          } 
        ];
        */
        /*
        authentication = ''
          local gitea all ident map=gitea-users
        '';
        # Map the gitea user to postgresql
        identMap = ''
          gitea-users gitea gitea
        '';
        */
      };

      # fix: error: postgresql_11 was removed, please upgrade your postgresql version.
      #services.postgresql.package = pkgs.postgresql_16;

      /*
      sops.secrets."postgres/gitea_dbpass" = {
        sopsFile = ../.secrets/postgres.yaml; # bring your own password file
        owner = config.services.gitea.user;
      };
      */

      # TODO use custom html templates
      # get rid of the stupid start page "A painless, self-hosted Git service"
      # https://forum.gitea.com/t/how-to-customize-the-landing-page/458/2
      # templates/home.tmpl
      # https://docs.gitea.com/next/administration/customizing-gitea
      # You can override the CustomPath by setting
      # either the GITEA_CUSTOM environment variable
      # or by using the --custom-path option on the gitea binary.

      # TODO add a "pages" server for static webhostig, similar to codeberg pages

      # error: The option `deployment' does not exist. Definition values:
      /*
      deployment.keys = {
        # /run/keys/gitea-dbpass
        gitea-dbpass = {
          text        = "xxx";
          user        = "gitea";
          group       = "wheel";
          permissions = "0640";
        };
      };
      */

      # https://mcwhirter.com.au/craige/blog/2019/Deploying_Gitea_on_NixOS/
      # nixpkgs/nixos/modules/services/misc/gitea.nix
      # TODO
      # https://github.com/RightToPrivacy/Gitea-Onion
      # -> no gitea config -> useless

      # TODO allow http://10.10.100.10:8100/
      # -> allow network access from host to container
      # https://stackoverflow.com/questions/46100966/how-to-make-nixos-container-visible-to-the-external-network
      # https://discourse.nixos.org/t/nixos-docker-and-the-host-network/11130

      # no. cgit is too ugly (but its fast)
      # see also https://github.com/milahu/cgit
      # FIXME "git clone" from cgit is slow
      /*
      #services.cgit-pink = {};
      services.cgit."milahuuuc365" = {
        enable = true;
        nginx.virtualHost = "milahuuuc365";
        # TODO port? default: port 80
        repos = {
          # FIXME mkdir
          # cgit-repos> ln: failed to create symbolic link '/nix/store/amqas9q3srnm4i7mawbi2f4rxmxccjzk-cgit-repos/milahu/alchi': No such file or directory
          #"milahu/alchi" = {
          "milahu_alchi" = {
            desc = "";
            # note: bare git repo
            # git clone --bare --branch master --single-branch file:///home/user/src/milahu/alchi
            path = "/var/lib/cgit/repos/milahu/alchi.git";
            #path = "milahu/alchi";
          };
        };
        package = pkgs.cgit-pink;
        #nginx.location = "";
        #settings
        #scanPath
      };
      */

      # too slow?
      # gitea disable syntax highlighting
      # http://10.10.100.20:8100/milahu/alchi/src/commit/bf17cfe9c9d94eaadae048818d5965b1eb15bd65/src/whoaremyfriends/wersindmeinefreunde.html#L2773
      # Page: 52132ms = 52 seconds!
      # Template: 12239ms
      services.gitea = rec {
        # FIXME why does it still say 1.21.4 not 1.21.6
        package = patchedPackages.gitea;
        enable = true;
        appName = "milahuuuc365";
        # after moving gitea service to container
        # machinectl shell root@milahuuuc365
        # systemctl stop gitea
        # chown -R gitea:gitea /var/lib/gitea
        # systemctl start gitea
        stateDir = "/var/lib/gitea";
        #customDir = "${stateDir}/custom";
        #repositoryRoot = "${stateDir}/repositories";
        database = {
          type = "postgres";
          # head -c1024 /dev/random | base64 -w0 | head -c100 >/run/keys/gitea-dbpass
          # no. Permission denied: '/run/keys/gitea-dbpass'
          # TODO move to container root
          # /var/lib/containers/milahuuuc365/
          #passwordFile = "/run/keys/gitea-dbpass";
          # sudo mv /var/lib/gitea /var/lib/containers/milahuuuc365/var/lib/gitea
          passwordFile = "${stateDir}/gitea-dbpass";
        };

        settings = {

          "highlight.mapping" = {
            # map file_extension to language. example: .toml = ini
            # FIXME disable syntax highlighting
            # see also https://github.com/go-gitea/gitea/issues/2011
            "*" = "nohighlight"; # no effect
            ".*" = "nohighlight"; # no effect
            ".html" = "nohighlight"; # no effect
          };

          # git-lfs
          #lfs.enable = false;
          #lfs.contentDir = "${stateDir}/data/lfs";

          server = {

            # Disable use of CDN for static files and Gravatar for profile pictures.
            OFFLINE_MODE = true;

            # public URL
            # TODO verify: this should be inferred from the currentl url
            # FIXME this should be empty
            # https://github.com/go-gitea/gitea/issues/29404
            # markdown: wrong hostname in commit url with empty ROOT_URL
            #ROOT_URL = "http://milahuuuc3656fettsi3jjepqhhvnuml5hug3k7djtzlfe4dw6trivqd.onion/";
            #ROOT_URL = "http://milahuuuc3656fettsi3jjepqhhvnuml5hug3k7djtzlfe4dw6trivqd.onion/src/";
            # no... gitea only works on root, at least with lighttpd
            # maybe nginx or apache work better
            #ROOT_URL = "/src/";
            ROOT_URL = "";

            # Listen port
            HTTP_PORT = 8100;

            # Listen address
            # default: listen on all interfaces
            # -> http://10.10.100.20:8100/
            #HTTP_ADDR = "127.0.0.1";

            # used for links in markdown
            #DOMAIN = "localhost";
            #DOMAIN = "milahuuuc3656fettsi3jjepqhhvnuml5hug3k7djtzlfe4dw6trivqd.onion";
            # default is "localhost"
            # TODO: grep ^DOMAIN /var/lib/gitea/custom/conf/app.ini
            DOMAIN = "";

            LANDING_PAGE = "explore"; # home, explore, organizations, login, custom

            # Enable Git LFS support.
            #LFS_START_SERVER = true;

            # Upper level of template and static files path
            # /nix/store/5haj5rq4cy10rvsv7dv5bn8prmfzhday-gitea-1.21.4-data
            #STATIC_ROOT_PATH = "${package}.data";
            #STATIC_ROOT_PATH = "${stateDir}/static";
            #STATIC_ROOT_PATH = "${stateDir}/gitea_custom/gitea";
            STATIC_ROOT_PATH = "${stateDir}/gitea-1.21.6-data-fork";

            DISABLE_SSH = true;

          };

          mailer = {
            ENABLED = false;
          };

          admin = {
            # Disallow regular (non-admin) users from creating organizations.
            DISABLE_REGULAR_ORG_CREATION = true;
            # User cannot delete their own account
            USER_DISABLED_FEATURES = "deletion";
          };

          # Cron - Garbage collect all repositories
          "cron.git_gc_repos" = {
            ENABLED = true;
            #RUN_AT_START = true;
            #SCHEDULE = "@every 72h"; # every 3 days
            SCHEDULE = "@every 240h"; # every 10 days
            # FIXME Error: gocron: cron expression failed to be parsed: failed to parse duration @every 3d: time: unknown unit "d" in duration "3d"
            #SCHEDULE = "@every 3d"; # every 3 days
          };

          service = {
            # https://docs.gitea.com/next/administration/config-cheat-sheet#service-service
            # ask for mail confirmation of registration
            REGISTER_EMAIL_CONFIRM = false;
            # manually confirm new registrations
            REGISTER_MANUAL_CONFIRM = true;
            #DISABLE_REGISTRATION = false;
            DISABLE_REGISTRATION = true;
            # use captcha validation for registration
            ENABLE_CAPTCHA = true;
            # require captcha validation for login
            REQUIRE_CAPTCHA_FOR_LOGIN = true;
            CAPTCHA_TYPE = "image"; # image, recaptcha, hcaptcha, mcaptcha, cfturnstile
            # Give new users restricted permissions by default
            DEFAULT_USER_IS_RESTRICTED = true;
            # Allow new users to create organizations by default
            DEFAULT_ALLOW_CREATE_ORGANIZATION = false;
            # use local avatars only
            # http://localhost:8100/admin/config
            # Picture and Avatar Configuration -> Disable Gravatar
          };
          ui = {
            #DEFAULT_THEME = "gitea-auto"; # gitea-auto, gitea-light, gitea-dark
            # default: 20 per page
            # Number of repositories that are shown in one explore page.
            EXPLORE_PAGING_NUM = 100;
            # Number of issues that are shown in one page
            ISSUE_PAGING_NUM = 100;
            # Number of members that are shown in organization members.
            MEMBERS_PAGING_NUM = 100;
            # Number of items that are displayed in home feed.
            #FEED_PAGING_NUM = 100;
            # TODO remove "ambiguous unicode characters" from sources
            # Detect ambiguous unicode characters in file contents and show warnings on the UI
            #AMBIGUOUS_UNICODE_DETECTION = false;
          };
          other = {
            #SHOW_FOOTER_VERSION = false;
            #SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
          };
          indexer = rec {
            # https://github.com/meilisearch/meilisearch # 40K stars, Rust
            # https://github.com/blevesearch/bleve # 10K stars, Go
            #ISSUE_INDEXER_TYPE = "bleve"; # bleve, meilisearch, elasticsearch
            #ISSUE_INDEXER_CONN_STR = "http://:${meilisearchMasterKey}@127.0.0.1:7700";
            # Enable code search (uses a lot of disk space, about 6 times more than the repository size).
            REPO_INDEXER_ENABLED = true;
            REPO_INDEXER_EXCLUDE = "*.jpg,*.jpeg,*.gif,*.png,*.webp,*.svg,*.mp4,*.mp3,*.opus,*.wav,*.flac,*.aac,*.m4a";
            MAX_FILE_SIZE = 5 * 1024 * 1024; # 5 MiB. default 1 MiB
            #REPO_INDEXER_TYPE = "meilisearch" # https://github.com/go-gitea/gitea/issues/25976
            #REPO_INDEXER_TYPE = "bleve"; # bleve, elasticsearch
            STARTUP_TIMEOUT = -1; # disable timeout. default 30
            #ISSUE_INDEXER_PATH = "data/indexers/issues.bleve"; # default
            #REPO_INDEXER_PATH = "data/indexers/repos.bleve"; # default
          };
        };
      }; # end of services.gitea

      /*
      # somewhere between cgit and gitea
      # TODO disable tilde prefix "~" before usernames
      services.sourcehut = {
        enable = true;
        #listenAddress = "";
        postgresql = {
          enable = true;
        };
        settings = {};
      };
      */

      /*
      services.meilisearch = {
        enable = true;
        listenAddress = "127.0.0.1";
        listenPort = 7700;
        maxIndexSize = "10 GiB"; # default: 100 GiB
        masterKeyEnvironmentFile = pkgs.writeText "meilisearch-masterKeyEnvironment" ''
          MEILI_MASTER_KEY=${meilisearchMasterKey}
        '';
      };
      */

      # TODO enable file upload
      services.openssh = {
        #enable = true;
        settings = (
          (
            if true then
            #if false then # test: enabe password auth
            {
              # disable password auth
              # require public key authentication for better security
              # TODO dynamic auth https://serverfault.com/questions/518821/how-can-you-do-dynamic-key-based-ssh-similar-to-github
              PasswordAuthentication = false; # whether password authentication is allowed
              KbdInteractiveAuthentication = false; # whether keyboard-interactive authentication is allowed.
              UsePAM = false; # PAM authentication
            }
            else
            {
              # test: enabe password auth
              PasswordAuthentication = true;
              KbdInteractiveAuthentication = true;
              UsePAM = true;
            }
          )
          //
          {
            # TODO? is this public key auth?
            challengeResponseAuthentication = true;

            # default = "prohibit-password";
            PermitRootLogin = "no";

            # whether sshd(8) should look up the remote host name
            UseDns = false;

            #GatewayPorts = "no"; # whether remote hosts are allowed to connect to ports forwarded for the client. See: man 5 sshd_config

            # check file modes and ownership of directories
            # set this to "false" to fix login error "permission denied"
            StrictModes = false;

            # login is allowed only for the listed users.
            AllowUsers = [
              "rsync"
            ];

            # print /etc/motd when a user logs in interactively
            PrintMotd = false;
          }
        );

      }; # services.openssh

      # TODO enable file upload
      services.rsyncd = {
        #enable = true;
        port = 873; # TCP port the daemon will listen on.
        #address = "localhost"; # no longer has any effect
        # see man 5 rsyncd.conf
        settings = {
          global = {
            #uid = "nobody"; gid = "nobody";
            uid = "rsync"; gid = "users";
            "use chroot" = true; # rsync should chroot to the the defined module path before the transfer is started
            "max connections" = 4;
            "hosts allow" = "localhost"; # allow only access via ssh
            "hosts deny" = "all";
            exclude = "lost+found/";
            "transfer logging" = "yes";
            timeout = 900;
            "ignore nonreadable" = "yes"; # ignore files that are not readable by the user the transfer is running as
            # files that must not be compressed during the transfer
            "dont compress" = (
              "*.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2 " +
              "*.rar *.7z *.iso " + 
              "*.mp4 *.mkv *.webm *.ogv *.avi *.flv " +
              "*.ogg *.mp3 *.m4a *.aac *.ac3 *.mka " +
              "*.jpg *.gif *.png *.webp " +
              ""
            );
          };
          rsync = {
            # note: this path is inside the container
            #path = "/home/rsync"; # no, this would give access to /home/rsync/.ssh
            path = "/home/rsync/tmp";
            #path = "/tmp/rsync"; # no, /tmp can be deleted on reboot
            #comment = "whole ftp area";
            #"read only" = "yes";
            #"write only" = "yes";
            #"auth users" = [ "tridge" "susan" ];
            #"secrets file" = "/etc/rsyncd.secrets";
          };
        };
        #socketActivated = false; # Rsync will be socket-activated rather than run persistently.
        
      }; # services.rsyncd

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users."rsync" = {
        isNormalUser = true;
        #isSystemUser = true;
        # TODO group
        extraGroups = [
        ];
        home = "/home/rsync";
        homeMode = "777";
        #shell = null;
        createHome = true;
        password = "rsync"; # test
      };

    };
  };





  # Enable CUPS to print documents.
  services.printing.enable = true;

  # journalctl --catalog --follow --unit=cups
  services.printing.logLevel = "debug";

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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."user" = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker" # WARNING the docker group membership is effectively equivalent to being root! https://github.com/moby/moby/issues/9976
      "dialout" # arduino programming
      "cdrom" # burn cd/dvd
      "libvirtd" # virt-manager, virtualbox
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

  # TODO microvm.nix -> ignite

  #virtualisation.containerd.enable = true; # todo

  # needed for
  # https://github.com/LanikSJ/dfimage
  # https://github.com/mrhavens/Dedockify
  # https://github.com/CenturyLinkLabs/dockerfile-from-image
  # -> reverse-engineer https://hub.docker.com/layers/sharelatex/sharelatex
  # https://github.com/pfichtner/pfichtner-freetz
  virtualisation.docker.enable = true;

  /*
    virtualisation = {
    podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    #dockerCompat = true;
    };
    };
  */

  /*
  # expensive, requires compilation -> use virt-manager
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "user" ];
  */

  # TODO why needed?
  /*
  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  #environment.systemPackages = with pkgs; [ virt-manager ];
  */

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true; # /etc/ssh/ssh_config
    # fix? gpg: agent_genkey failed: No pinentry
    # todo: also add pinentry to env pkgs
    pinentryPackage = pkgs.pinentry-qt; # kde
    #pinentryPackage = pkgs.pinentry-gnome3; # gnome
    #pinentryPackage = pkgs.pinentry-gtk2; # gnome
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.

  # https://discourse.nixos.org/t/overwrite-firewall-settings/9343/16
  /*
    networking.firewall.allowedTCPPorts = lib.mkForce [ <only the ports I want> ];
    networking.firewall.allowedUDPPorts = lib.mkForce [ <only the ports I want> ];
  */

  networking.firewall.allowedTCPPorts = lib.mkForce [
    #80 # http
    #443 # https
    #21 # ftpd

    7075 # nano-wallet

    2049 # nfs

    #8000 # http
    #8080 # http

    #138 # NetBIOS Datagram
    #139 # NetBIOS Session
    #389 # LDAP
    #445 # SMB over TCP = samba
    #5357 # samba-wsdd
  ];

# TODO the udp port 6771 may change with restart of qBittorrent
# https://github.com/qbittorrent/qBittorrent/issues/13461
# Inbound DHT connections broken for IPv6
/*
$ network-list-open-ports.sh | grep -w qbittorrent 
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 84.167.63.83:6881       0.0.0.0:*               LISTEN      684910/qbittorrent  
udp        0      0 0.0.0.0:6771            0.0.0.0:*                           684910/qbittorrent  
udp        0      0 84.167.63.83:6881       0.0.0.0:*                           684910/qbittorrent  
*/

  networking.firewall.allowedUDPPorts = lib.mkForce [
    #3702 # samba-wsdd
    6771 # bittorrent dynamic udp port
  ];

  networking.firewall.allowedTCPPortRanges = lib.mkForce [
    #{ from = 51000; to = 51999; } # ftpd passive mode
    { from = 6881; to = 6889; } # torrent default ports
    #{ from = 25410; to = 25510; } # torrent
    { from = 8501; to = 8502; } # pyload
  ];

  networking.firewall.allowedUDPPortRanges = lib.mkForce [
    #{ from = 51000; to = 51999; } # ftpd passive mode
    #{ from = 49152; to = 49252; } # services.proftpd
    { from = 6881; to = 6889; } # torrent default ports
  ];

/*
  services.proftpd = {
    enable = true;
    name = "milahu's ftp";
    port = 21;
    passivePortRangeFrom = 49152;
    passivePortRangeTo = 49252;
    logLevel = "debug";
    debugLevel = 10;
    #passivePortRangeTo = 65535;
    #extraConfig = builtins.readFile ./proftpd.conf;
    extraConfig = ''
      # Limit downloads for everyone
      TransferRate RETR 3500
      # FIXME fatal: unknown configuration directive 'ShaperEngine'
      # enable traffic shaping http://www.proftpd.org/docs/contrib/mod_shaper.html
      # see also TransferRate http://www.proftpd.org/docs/modules/mod_xfer.html#TransferRate
      #ShaperEngine on
      # Change the overall daemon rate to 100 KB/s
      # Limit total download rate to 3500 KB/s
      # - hard limit is 4000 KB/s which produces frequent connection loss to ISP (new IP address)
      # Limit total upload rate to 500 KB/s
      #ShaperAll downrate 3500 uprate 500
      # no chmod
      <Limit SITE_CHMOD>
        DenyAll
      </Limit>
      # anon only
      <Limit LOGIN>
        DenyAll
      </Limit>
      #<Anonymous /home/user/down/torrent/seed/Heimat.Defender.2021.Kvltgames.EinProzent>
      <Anonymous /home/user/src/opensubtitles-dump/release>
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
*/

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

  /*
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
  */

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

  # debug
  #networking.firewall.enable = false;

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
    };
  };

  # ?
  security.chromiumSuidSandbox.enable = true;

  environment.systemPackages = with pkgs; [

    #subtitleeditor # TODO test with patched gstreamermm
    # ^^ crap. use gaupol


    #    pkgs.nur.repos.mic92.hello-nur

    # TODO whats the difference?
    # https://github.com/NixOS/nixpkgs/issues/112046
    # RFP: Video DownloadHelper Companion App (vdhcoapp)
    #nur.repos.sigprof.vdhcoapp # 1.6.3
    #nur.repos.wolfangaukang.vdhcoapp # 1.6.3 # TODO
    nur.repos.milahu.vdhcoapp
    #nur.repos.wolfangaukang2.vdhcoapp
    # vdhcoapp # TODO use vdhcoapp from nixpkgs
    # https://github.com/NixOS/nixpkgs/pull/300051

    #nur.repos.milahu.python3.pkgs.pygubu-designer # python tkinter gui designer

    #easyeffects # effects for pulseaudio + equalizer # FIXME not working

    # daw: digital audio workstation
    # note: this does not work in nix-shell
    # because ardour does not use pkg-config to locate the /lib path of lsp-plugins
    # $ pkg-config --list-all | cut -d' ' -f1 | xargs pkg-config --libs-only-L
    # -L/nix/store/l37r2iz78gagcvvc4g5j7argqi81kchi-lsp-plugins-1.2.14/lib
    # $ ls /nix/store/l37r2iz78gagcvvc4g5j7argqi81kchi-lsp-plugins-1.2.14/lib/vst/lsp-plugins/*.so | wc -l 
    # 177
    ardour
    lsp-plugins

    # audio live coding
    sonic-pi

    #firejail # security

    #xpra # firejail --x11=xpra
    #xorg.xauth # firejail --x11=xorg
    xorg.xhost

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

    #torsocks
    #tightvnc # -> tigervnc
    #tigervnc

    wget

    curl
    curl.dev
    # TODO move to pyload
    # curl.dev provides curl-config, needed by pyload

    dig

    #websocat # "curl for websocket"

    git

    #git-lfs # upload large files (>100MB) to github

    #git-repo-filter # delete files in git history

    # "git filter-branch" is deprecated in favor of "git filter-repo"
    #git-filter-repo
    # fix: No manual entry for git-filter-repo
    nur.repos.milahu.git-filter-repo

    speedtest-cli

    #ipfs
    #ipfs-desktop # TODO undefined

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
    /*
    (hiPrio (parallel.overrideAttrs (oldAttrs: rec {
      pname = "parallel";
      version = "20231022";
      src = fetchurl {
        url = "mirror://gnu/parallel/${pname}-${version}.tar.bz2";
        sha256 = "sha256-k/K5TxhQeYpLXdoiva6G2ramVl41JYYOCORvJWPzJow=";
      };
      # also install man pages
      configureFlags = [
        "--enable-documentation" # no effect
        #"--disable-documentation" # no
        #"--disable-documentation=yes" # parallel> configure: error: invalid feature name: `documentation=yes'
      ];
      postUnpack = ''
        cd $sourceRoot
        set -x
        grep parallel.1 -F -r . || true
        #head -n9999 Makefile* || true
        set +x
        cd ..
      '';
      postInstall = ''
        #make install-man # make: Nothing to be done for 'install-man'.
        cd src
        make install-man # make: Nothing to be done for 'install-man'.
        cd ..

        wrapProgram $out/bin/parallel \
          --prefix PATH : "${lib.makeBinPath [ procps perl coreutils gawk ]}"

        set -x
        #head -n9999 Makefile* || true
        find $out -type f

        set -x
        grep parallel.1 -F -r . || true
        set +x

        #exit 1
      '';
    })))
    */
    # extra hiPrio to prefer parallel-full/bin/parallel over parallel/bin/parallel
    # no, this has no effect
    # readlink -f $(which parallel) # this still says parallel, not parallel-full
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

    spectacle # screenshot

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
    # but it should "just work" after a fresh install with zero user state

    #neovim

    #python3.pkgs.jedi # python language server

    /*
      File "/home/user/.vscode-oss/extensions/ms-python.isort-2023.10.1-universal/bundled/tool/lsp_server.py", line 38, in <module>
      import isort
      ModuleNotFoundError: No module named 'isort'
    */
    # moved to python3.withPackages
    #python3.pkgs.isort

    # TODO? why?
    /*
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        #ms-python.vscode-pylance # python language server # unfree -> python3.pkgs.jedi
        #ms-azuretools.vscode-docker
        #ms-vscode-remote.remote-ssh
        golang.go
        #ms-vscode.cpptools # unfree
        redhat.vscode-yaml
        matklad.rust-analyzer
        # TODO javascript
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        /*
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
        *xxxxxxxxx/
      ];
    })
    */

    /*
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
    */

    #lapce # editor, xi-editor

    #clang-tools # clangd = c/cpp lang server
    #rnix-lsp # nix lang server for vscodium # old? build from git

    #meld # Visual diff and merge tool

    okular # document viewer, ebook reader

    # use latest version to fix bold font in PDF export
    # https://duckduckgo.com/?q=libreoffice+writer+bold+font+lost+pdf
    # https://ask.libreoffice.org/t/exporting-to-pdf-un-bolds-bolded-text/83665
    # https://bugs.documentfoundation.org/show_bug.cgi?id=108497
    # https://bugs.documentfoundation.org/show_bug.cgi?id=103596
    #libreoffice
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
    nur.repos.milahu.tor-browser_13_0_13

    mpv # video player

    # TODO
    #nur.repos.milahu.svn2github

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

    konsole
    #    dolphin # qt file manager

    nodejs_latest

    #wireguard-tools # VPN

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

    # python2
    #(python.withPackages (pp: with pp; [ packaging ])) # not working in inkscape
    #python # needed for inkscape (save as optimized svg)
    #python.pkgs.packaging # not working in inkscape

    #nftables # for wireguard

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
    /*
    (nix-init.overrideAttrs (oldAttrs: {
      # https://github.com/nix-community/nix-init/issues/84
      src = fetchFromGitHub {
        owner = "nix-community";
        repo = "nix-init";
        rev = "45bdd3d986e65edef8dc648753480f732690211d";
        sha256 = "sha256-JsbPI4abrBApGi2wI9728V3zbfi9nnl1hu5ShJEqVzA=";
      };
      cargoSha256 = "0000000000000000000000000000000000000000000000000000"; # no effect
    }))
    */

    k3b # cd/dvd writer
    /*
      FIXME k3b cannot find dependencies
      the problem is:
      "k3b > settings > programs" shows multiple choices for some programs.

      example:

      cdrecord
        /run/current-system/sw/bin/cdrecord
        /nix/store/j7d1bd9gg29jfr2q802c1m7lk345xw0z-cdrkit-1.1.11/bin/wodim

      the first path is a symlink to the second path

      $ which cdrecord
      /run/current-system/sw/bin/cdrecord

      $ readlink -f /run/current-system/sw/bin/cdrecord
      /nix/store/j7d1bd9gg29jfr2q802c1m7lk345xw0z-cdrkit-1.1.11/bin/wodim

      so this is a bug in k3b

      Unable to find cdrecord executable
      K3b uses cdrecord to actually write CDs.
      Solution: Install the cdrtools package which contains cdrecord.

      Unable to find growisofs executable
      K3b uses growisofs to actually write DVDs. Without growisofs you will not be able to write DVDs. Make sure to install at least version 5.10.
      Solution: Install the dvd+rw-tools package.

      Unable to find dvd+rw-format executable
      K3b uses dvd+rw-format to format DVD-RWs and DVD+RWs.
      Solution: Install the dvd+rw-tools package.
    */
    # k3b dependencies:
    dvdplusrwtools # growisofs dvd+rw-format
    #cdrtools # cdrecord
    cdrkit # cdrecord

    # 4.12 + antlr4-parse
    # patch sent per email to nick cao
    #nur.repos.milahu.antlr4

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

    # FIXME: system-path> warning: collision between `/nix/store/cjipx2k0c4aba4x9802w9vg2yjym624w-exfatprogs-1.2.1/sbin/fsck.exfat' and `/nix/store/vjyzyl43qbxkg7z8srg5d251nhawqa84-exfat-1.4.0/sbin/fsck.exfat'
    exfat
    #exfatprogs

    #hashcat # brute force cracking of hashes https://bpjmleak.neocities.org/

    /*
    dig # debug DNS resolve queries
    traceroute # debug network routes
    */

    # build rust package as many derivations
    # better than rustPlatform.buildRustPackage in nixpkgs
    # see also: https://nixos.wiki/wiki/Rust#Packaging_Rust_projects_with_nix
    #crate2nix
    #nur.repos.milahu.cargo2nix

    # no, this is a nix library, no cli tool
    #nur.repos.milahu.npmlock2nix # build javascript projects with nix

    /*
    nur.repos.milahu.radicle
    nur.repos.milahu.radicle-httpd
    #nur.repos.milahu.radicle-interface # TODO? should be used by radicle-httpd
    */

    # no. run pyload from source
    #nur.repos.milahu.pyload

    mlocate # mlocate, updatedb # find files in a filesystem with a cached database

    nur.repos.milahu.tap-bpm-cli # get tempo of music

    #nur.repos.milahu.gh2md # export github issues to markdown

    # https://github.com/ireun/magnetico
    # https://github.com/NixOS/nixpkgs/pull/197733 # magnetico: 0.12.0 -> unstable-2022-08-10
    #magnetico # bittorrent DHT search engine

    # ssb: secure scuttlebutt
    # https://github.com/NixOS/nixpkgs/issues/59100
    # https://github.com/NixOS/nixpkgs/pull/46000 # scuttlebot and git-ssb: init at 11.4.3 and 2.3.6
    # https://github.com/NixOS/nixpkgs/pull/49473 # git-ssb: add build dependency
    #   A problem with git-ssb is that the more recent versions are only available through ssb-npm. integrating a second registry into the global nodePackages seems messy...
    #   I’d be keen to work on a nixos ssb channel if there is more interest.
    #
    #   after reading up on ssb-npm, I see what the issue is. It's going to be a real pain integrating this into the nix infrastructure.
    #
    #   That is why I think a second channel / git tree that’s imports would be the most sensible.
    #   People could use the generate.sh to clone their own or trust a published version through a channel.
    #
    # https://github.com/NixOS/nixpkgs/pull/61530 # patchwork
    # https://github.com/NixOS/nixpkgs/pull/80446 # ssb-patchwork: 3.17.2 -> 3.17.4
    # https://github.com/NixOS/nixpkgs/issues/153763 # Manyverse # Manyverse is a cross-platform app for the ScuttleButt network
    #   https://www.manyver.se/
    #   https://gitlab.com/staltz/manyverse
    #
    # FIXME: error: Package ‘git-ssb-2.3.6’ in /nix/store/qb3dg4cx5jzk3pa8szzi0ziwnqy33p50-source/pkgs/development/node-packages/node-packages.nix:108446 is marked as broken, refusing to evaluate.
    #nodePackages.git-ssb
    #
    # FIXME: build from source
    # ssb gui, based on electron
    #ssb-patchwork
    #
    #ssb-patchbay # missing

    # vanity onion address generator
    #mkp224o

    # TODO use a larger default value for the http.postBuffer config
    #
    # error: RPC failed; HTTP 408 curl 18 HTTP/2 stream 7 was reset
    # send-pack: unexpected disconnect while reading sideband packet
    # fatal: the remote end hung up unexpectedly
    #
    # https://stackoverflow.com/questions/66366582/github-unexpected-disconnect-while-reading-sideband-packet
    #
    # git config --global http.postBuffer 157286400

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

    # read/write flash memory via USB flash programmers like ch341a_spi
    # ~/src/printer-hacking/flash-programmer/flashrom.sh
    #flashrom

    #inetutils # ftp

    #xcalib # invert colors: xcalib -i -a

    #nano-wallet # nanocoin, nanocurrency
    nur.repos.milahu.nano-node
    monero monero-gui
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

    nur.repos.milahu.mpv-downmix-gui

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

    torrenttools

    nur.repos.milahu.spotify-adblock

  ];
}

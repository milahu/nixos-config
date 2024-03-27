{ config, lib, pkgs, ... }:

with lib;

let
  # the values of the options set for the service by the user of the service
  cfg = config.services.ngrok;
in

{
  ##### interface. here we define the options that users of our service can specify
  options = {
    # the options for our service will be located under services.ngrok
    services.ngrok = { 
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable ngrok.
        '';
      };

      configFile = mkOption {
        type = types.str;
        default = "";
        example = "/home/user/.config/ngrok/ngrok.yml";
        description = ''
          Path to ngrok.yml.

          Example config:

          ```yaml
          version: "2"
          authtoken: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
          tunnels:
            web:
              proto: http
              addr: 80
            ssh:
              proto: tcp
              addr: 22
          ```
        '';
      };

      logLevel = mkOption {
        type = types.str;
        default = "info";
        example = "debug";
        description = ''
          logging level: 'debug', 'info', 'warn', 'error', 'crit' (default "info")
        '';
      };

      user = mkOption {
        type = types.str;
        default = "ngrok";
        example = "user";
      };

      group = mkOption {
        type = types.str;
        default = "ngrok";
        example = "users";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ngrok;
        defaultText = literalExpression "pkgs.ngrok";
      };
    };
  };

  config = mkIf cfg.enable {
    # https://github.com/vincenthsu/systemd-ngrok/blob/master/ngrok.service
    systemd.services.ngrok = {
      description = "ngrok client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/ngrok start --all --config ${cfg.configFile} --log stdout --log-level ${cfg.logLevel}";
        ExecReload = "/bin/kill -HUP $MAINPID";
        KillMode = "process";
        IgnoreSIGPIPE = true;
        Restart = "always";
        RestartSec = 3;
        Type = "simple";
      };
    };

    users.users = optionalAttrs (cfg.user == "ngrok") {
      ngrok = {
        group = cfg.group;
        #home = cfg.settings.data-dir;
        isSystemUser = true;
        description = "Daemon user for ngrok";
      };
    };

    users.groups = optionalAttrs (cfg.group == "ngrok") {
      ngrok = {};
    };

  };

}

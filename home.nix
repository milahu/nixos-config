#{ lib, pkgs, config, ... }:
{ lib, pkgs, config, nur, ... }:

let oldPkgs = pkgs; in
let pkgs = oldPkgs // { inherit nur; }; in

rec {
  programs.home-manager.enable = true;

  home.username = "user";
  home.homeDirectory = "/home/${home.username}";

  # compat with configuration.nix
  home.stateVersion = "23.11";

#      ${pkgs.nur.repos.milahu.vdhcoapp}/bin/vdhcoapp install
#      ${nur.repos.milahu.vdhcoapp}/bin/vdhcoapp install
  home.activation.installVdhcoapp = lib.hm.dag.entryAfter [
      #"writeBoundary"
      "installPackages"
    ] ''
      echo "home-manager: vdhcoapp install"
      #vdhcoapp install
      ${pkgs.nur.repos.milahu.vdhcoapp}/bin/vdhcoapp install
    '';

}

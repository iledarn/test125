{
  description = "Odoo v12.0 nix-od environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    pythonEnv = pkgs.python36.withPackages (ps: with ps; [
      requests
    ]);

    myEnv = pkgs.buildEnv {
      name = "my-python-env-3-6-";
      paths = with pkgs; [
        pythonEnv
      ];
    };
  in
  {
    packages.default = myEnv;

    apps.default = {
      type = "app";
      program = "${myEnv}/bin/python";
    };
  }
  );
}

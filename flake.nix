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
      Babel
      pypdf2
      passlib
      werkzeug
      lxml
      decorator
      dateutil
      psycopg2
      (pillow.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [
          (numpy.overridePythonAttrs (oldAttrs: rec {
            version = "1.19.5";
            src = oldAttrs.src.override {
              inherit version;
              sha256 = "0fdbaa32c9eb09ef09d425dc154628fca6fa69d2f7c1a33f889abb7e0efb3909";
            };
          }))
        ];
      }))
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

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
      (numpy.overridePythonAttrs (oldAttrs: rec {
        version = "1.19.5";  # This version should be compatible with Pillow 4.0.0
        src = pkgs.fetchPypi {
          pname = "numpy";
          inherit version;
          sha256 = "e5cf3fdf13401885e8eea8170624ec96225e2174eb0c611c6f26dd33b489e3ff";
        };
      }))
      (pillow.overridePythonAttrs (oldAttrs: rec {
        version = "4.0.0";
        src = pkgs.fetchPypi {
          pname = "Pillow";
          inherit version;
          sha256 = "ee26d2d7e7e300f76ba7b796014c04011394d0c4a5ed9a288264a3e443abca50";
        };
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [
          pkgs.python36Packages.olefile
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

{
  description = "Odoo v12.0 nix-od environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.05";
    flake-utils.url = "github:numtide/flake-utils";
    wkhtmltopdf-flake.url = "github:iledarn/wkhtmltopodfnix";
  };

  outputs = { self, nixpkgs, flake-utils, wkhtmltopdf-flake }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    pythonEnv = pkgs.python37.withPackages (ps: with ps; [
      requests
      Babel
      pypdf2
      passlib
      werkzeug
      lxml
      decorator
      dateutil
      psycopg2
      pillow
      setuptools
      psutil
      jinja2
      reportlab
      html2text
      docutils
      num2words
    ]);

    wkhtmltopdf = wkhtmltopdf-flake.packages.${system}.default;

    myEnv = pkgs.buildEnv {
      name = "my-python-env-3-6";
      paths = with pkgs; [
        pythonEnv
        postgresql_13
        wkhtmltopdf
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

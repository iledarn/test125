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

    gitaggregator = pkgs.python37Packages.buildPythonPackage rec {
      pname = "git-aggregator";
      version = "4.0.1";
      format = "wheel";  # Specify that this is a wheel

      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d3/39/7849f5b08226e4085de37a95095482475a7d3811ee7e736e9ce7cb9f2a45/git_aggregator-4.0.1-py3-none-any.whl";
        sha256 = "e4f6cbe6a1b6adda9c8d6838bd2248a42f189769e4eac4f724537e86b997aee4"; # Replace with actual hash
      };

      doCheck = false;  # Skip tests if they're causing issues
      propagatedBuildInputs = with pkgs.python37Packages; [
        pyyaml
        argcomplete
        colorama
        requests
      ];
    };

    pythonEnv = pkgs.python37.withPackages (ps: with ps; [
      gitaggregator
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
      xlrd
      cachetools
      XlsxWriter
      markdown
      google-auth
      google-auth-oauthlib
      google-api-python-client
      beautifulsoup4
      jira
      numpy
      xlwt
      phonenumbers
    ]);

    wkhtmltopdf = wkhtmltopdf-flake.packages.${system}.default;

    myEnv = pkgs.buildEnv {
      name = "my-python-env-3-7";
      paths = with pkgs; [
        pythonEnv
        sassc
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

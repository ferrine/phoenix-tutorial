{ callPackage, fetchFromGitHub }:
callPackage
  (fetchFromGitHub {
    owner = "canva-public";
    repo = "js2nix";
    rev = "d37912f6cc824e7f41bea7a481af1739ca195c8f";
    hash = "sha256-Bmv0ERVeb6vjYzy4MuCDgSiz9fSm/Bhg+Xk3AxPisBw=";
  })
{ }

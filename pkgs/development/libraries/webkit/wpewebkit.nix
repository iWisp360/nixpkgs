{
  callPackage,
  lib,
  clangStdenv,
  libwpe,
  libjpeg,
  fetchurl,
  ...
}@args:
let
  abiVersion = "2.0";
  version = "2.50.6";
  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpewebkit-${version}.tar.xz";
    hash = "sha256-iGT9P2EWNw11Ql+bHvpI6xiMz0LJKunoqvLdUfnyfe8=";
  };
in
callPackage ./common.nix (
  {
    port = "wpe";
    inherit src version;

    extraBuildInputs = [
      libwpe
      libjpeg
    ];

    meta = {
      description = "Web content rendering engine, WPE port";
      mainProgram = "WebKitWebDriver";
      homepage = "https://wpewebkit.org/";
      license = lib.licenses.bsd2;
      pkgConfigModules = [
        "wpewebkit-${abiVersion}"
        "wpewebkit-web-process-extension-${abiVersion}"
      ];

      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      maintainers = [ lib.maintainers.iwisp360 ];
      broken = clangStdenv.hostPlatform.isDarwin;
    };
  }
  // args
)

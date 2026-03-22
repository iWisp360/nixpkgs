{
  callPackage,
  lib,
  clangStdenv,
  gtk4,
  fetchurl,
  gobject-introspection,
  gi-docgen,
  ...
}@args:
let
  abiVersion = if lib.versionAtLeast gtk4.version "4.0" then "6.0" else "4.1";
  version = "2.50.6";
  src = fetchurl {
    url = "https://webkitgtk.org/releases/webkitgtk-${version}.tar.xz";
    hash = "sha256-Kygav4iU/8YXIVLlZgt17u7b4cxD1ng9Cdx598hlu0I=";
  };
in
callPackage ./common.nix (
  {
    port = "gtk";
    inherit
      abiVersion
      gtk4
      src
      version
      ;

    extraPropagatedBuildInputs = [
      gtk4
    ];

    extraNativeBuildInputs = [
      gobject-introspection
      gi-docgen
    ];

    meta = {
      description = "Web content rendering engine, GTK port";
      mainProgram = "WebKitWebDriver";
      homepage = "https://webkitgtk.org/";
      license = lib.licenses.bsd2;
      pkgConfigModules =
        if lib.versionAtLeast abiVersion "6.0" then
          [
            "javascriptcoregtk-${abiVersion}"
            "webkitgtk-${abiVersion}"
            "webkitgtk-web-process-extension-${abiVersion}"
          ]
        else
          [
            "javascriptcoregtk-${abiVersion}"
            "webkit2gtk-${abiVersion}"
            "webkit2gtk-web-extension-${abiVersion}"
          ];

      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      teams = [ lib.teams.gnome ];
      broken = clangStdenv.hostPlatform.isDarwin;
    };
  }
  // args
)

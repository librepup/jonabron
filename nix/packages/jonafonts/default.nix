{ pkgs ? import <nixpkgs> {} }:
rec {
  mkFont = { name, files }: pkgs.stdenv.mkDerivation {
    inherit name;
    version = "1.0";
    src = ./files;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      ${builtins.concatStringsSep "\n" (map (f: "cp -v ${f} $out/share/fonts/truetype/ 2>/dev/null || true") files)}
    '';
  };
  synapsian = mkFont {
    name = "jonafonts-synapsian";
    files = [
      "synapsian.ttf"
    ];
  };
  karamarea = mkFont {
    name = "jonafonts-karamarea";
    files = [
      "Karamarea-Bold.ttf"
      "Karamarea-SimpleHex.ttf"
    ];
  };
  templeos = mkFont {
    name = "jonafonts-templeos";
    files = [
      "templeos_font.ttf"
    ];
  };
  icons = mkFont {
    name = "jonafonts-icons";
    files = [
      "weathericons.ttf"
      "SymbolsNerdFontMono-Regular.ttf"
      "SymbolsNerdFont-Regular.ttf"
      "octicons.ttf"
      "material-design-icons.ttf"
      "fontawesome.ttf"
      "file-icons.ttf"
      "all-the-icons.ttf"
    ];
  };
  lucidabright = mkFont {
    name = "jonafonts-lucidabright";
    files = [
      "lucida-bright.ttf"
    ];
  };
  blexmono = mkFont {
    name = "jonafonts-blexmono";
    files = [
      "BlexMonoNerdFont-Bold.ttf"
      "BlexMonoNerdFont-BoldItalic.ttf"
      "BlexMonoNerdFont-ExtraLight.ttf"
      "BlexMonoNerdFont-ExtraLightItalic.ttf"
      "BlexMonoNerdFont-Italic.ttf"
      "BlexMonoNerdFont-Light.ttf"
      "BlexMonoNerdFont-LightItalic.ttf"
      "BlexMonoNerdFont-Medium.ttf"
      "BlexMonoNerdFont-MediumItalic.ttf"
      "BlexMonoNerdFont-Regular.ttf"
      "BlexMonoNerdFont-SemiBold.ttf"
      "BlexMonoNerdFont-SemiBoldItalic.ttf"
      "BlexMonoNerdFont-Text.ttf"
      "BlexMonoNerdFont-TextItalic.ttf"
      "BlexMonoNerdFont-Thin.ttf"
      "BlexMonoNerdFont-ThinItalic.ttf"
      "BlexMonoNerdFontMono-Bold.ttf"
      "BlexMonoNerdFontMono-BoldItalic.ttf"
      "BlexMonoNerdFontMono-ExtraLight.ttf"
      "BlexMonoNerdFontMono-ExtraLightItalic.ttf"
      "BlexMonoNerdFontMono-Italic.ttf"
      "BlexMonoNerdFontMono-Light.ttf"
      "BlexMonoNerdFontMono-LightItalic.ttf"
      "BlexMonoNerdFontMono-Medium.ttf"
      "BlexMonoNerdFontMono-MediumItalic.ttf"
      "BlexMonoNerdFontMono-Regular.ttf"
      "BlexMonoNerdFontMono-SemiBold.ttf"
      "BlexMonoNerdFontMono-SemiBoldItalic.ttf"
      "BlexMonoNerdFontMono-Text.ttf"
      "BlexMonoNerdFontMono-TextItalic.ttf"
      "BlexMonoNerdFontMono-Thin.ttf"
      "BlexMonoNerdFontMono-ThinItalic.ttf"
      "BlexMonoNerdFontPropo-Bold.ttf"
      "BlexMonoNerdFontPropo-BoldItalic.ttf"
      "BlexMonoNerdFontPropo-ExtraLight.ttf"
      "BlexMonoNerdFontPropo-ExtraLightItalic.ttf"
      "BlexMonoNerdFontPropo-Italic.ttf"
      "BlexMonoNerdFontPropo-Light.ttf"
      "BlexMonoNerdFontPropo-LightItalic.ttf"
      "BlexMonoNerdFontPropo-Medium.ttf"
      "BlexMonoNerdFontPropo-MediumItalic.ttf"
      "BlexMonoNerdFontPropo-Regular.ttf"
      "BlexMonoNerdFontPropo-SemiBold.ttf"
      "BlexMonoNerdFontPropo-SemiBoldItalic.ttf"
      "BlexMonoNerdFontPropo-Text.ttf"
      "BlexMonoNerdFontPropo-TextItalic.ttf"
      "BlexMonoNerdFontPropo-Thin.ttf"
      "BlexMonoNerdFontPropo-ThinItalic.ttf"
    ];
  };
  all = pkgs.symlinkJoin {
    name = "jonafonts-all";
    paths = [ synapsian karamarea templeos icons lucidabright blexmono ];
  };
  default = all;
}

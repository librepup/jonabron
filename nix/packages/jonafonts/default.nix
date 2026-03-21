{ pkgs ? import <nixpkgs> {} }:
rec {
  mkFont = { name, files }: pkgs.stdenv.mkDerivation {
    inherit name;
    version = "1.0";
    src = builtins.path {
      path = ./files;
      name = "${name}-src";
      filter = (path: type:
        let
          filename = baseNameOf path;
        in
          builtins.elem filename files
      );
    };
    meta = with pkgs.lib; {
      description = "Jonafonts Bundles";
      homepage = "https://github.com/librepup/jonabron";
      maintainers = [ maintainers.librepup ];
      license = licenses.gpl3Plus;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/{truetype,opentype,woff2,other}
      for f in *; do
        if [ -f "$f" ]; then
          if [[ "$f" == *.otf ]]; then
            cp -v "$f" $out/share/fonts/opentype/
          elif [[ "$f" == *.ttf ]]; then
            cp -v "$f" $out/share/fonts/truetype/
          elif [[ "$f" == *.woff2 ]]; then
            cp -v "$f" $out/share/fonts/woff2/
          else
            cp -v "$f" $out/share/fonts/other/
          fi
        fi
      done
    '';
  };
  synapsian = mkFont {
    name = "jonafonts-synapsian";
    files = [
      "synapsian.ttf"
    ];
  };
  joglobal = mkFont {
    name = "jonafonts-joglobal";
    files = [
      "Joglobal.ttf"
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
  w95fa = mkFont {
    name = "jonafonts-w95fa";
    files = [
      "W95FA.otf"
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
    paths = [ synapsian karamarea templeos icons lucidabright blexmono w95fa joglobal ];
  };
  default = all;
}

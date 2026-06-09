{
  stdenv,
  lib,
  libsForQt5,
  fetchFromGitHub,
  gnumake,
  libcap,
  which,
  sudo,
}:

let
  customQtConnectivity = libsForQt5.qtconnectivity.overrideAttrs (oldAttrs: {
    version = "5.7.1-roleswitch";
    src = fetchFromGitHub {
      owner = "schultetwin1";
      repo = "qtconnectivity";
      rev = "e0e4a2b84050cfd55bb25388a602668a953eafd7";
      sha256 = "sha256-MIAyBa4ZeZqYnGCslK40QWtf7KHjwOyL4ZRhI5gKuT8=";
    };
    patches = [];
  });
in
stdenv.mkDerivation rec {
  pname = "desktopancs";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "schultetwin1";
    repo = "DesktopANCS";
    rev = "cf99c343555751d36e6f7fd70c0e1b53c2710b27";
    sha256 = "sha256-rBUHXlcBeEzPnonKtb0UajUfrD9Zv2Fnmk0kIxkZL5c=";
  };
  buildInputs = [
    libsForQt5.qtbase
    customQtConnectivity
    libcap
    sudo
  ];
  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    gnumake
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share

    cp DesktopANCS $out/bin/DesktopANCS

    cat <<EOF > $out/bin/desktopancs-set-bluetooth-permission
#!/usr/bin/env bash
exec ${sudo}/bin/sudo ${libcap}/bin/setcap cap_net_raw+eip $out/bin/DesktopANCS "\$@"
EOF

    chmod +x $out/bin/desktopancs-set-bluetooth-permission

    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/schultetwin1/DesktopANCS";
    description = "A way to get Notifications from your iPhone to your Linux Machine using Bluetooth.";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib; [ maintainers.librepup ];
    platforms = lib.platforms.linux;
  };
}

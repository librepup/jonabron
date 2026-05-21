{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "ratctl-udevrules";
  version = "0.1.1";
  src = pkgs.fetchFromGitHub {
    owner = "MayeulC";
    repo = "Saitek";
    rev = "ef9d36c0fb0cb7756e330f5c8c7e4b0e3ba09f8b";
    sha256 = "sha256-eMVUS3FZVnZ24iu+ERvKvJH4f0aYesaDzKI42iaHE4U=";
  };
  nativeBuildInputs = [
    pkgs.makeWrapper
  ];
  dontBuild = true;
  installPhase = ''
    # Pre Install Hook
    runHook preInstall

    # Create Directories
    mkdir -p $out/lib/udev/rules.d

    # Install UDev Rules
    install -Dpm644 $src/90-ratctl.rules $out/lib/udev/rules.d/90-ratctl.rules

    # Post Install Hook
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/MayeulC/Saitek";
    description = "Mad Catz R.A.T. Mice UDev Rules.";
    license = pkgs.lib.licenses.gpl3Plus;
    maintainers = with pkgs.lib; [ maintainers.librepup ];
    platforms = pkgs.lib.platforms.linux;
  };
}

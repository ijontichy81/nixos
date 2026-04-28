{
  lib,
  stdenvNoCC,
  inkscape,
  just,
  xcursorgen,
  catppuccin-whiskers,
  python3,
  python3Packages,
  zip,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-cursors-mocha-green";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v2.0.0";
    hash = "sha256-qis6p+/m7+DdRDYzLq9yB2eZGpfZe5z5xRsa/1HoIG4=";
  };

  nativeBuildInputs = [
    just
    inkscape
    xcursorgen
    catppuccin-whiskers
    python3
    python3Packages.pyside6
    zip
  ];

  buildFlags = [ "-f mocha" "-a green" ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    just build mocha green
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    mv dist/catppuccin-mocha-green-cursors $out/share/icons/
    runHook postInstall
  '';

  meta = {
    description = "Catppuccin mocha green cursor theme";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
{ lib
, stdenv
, fetchurl
, atomEnv
, systemd
, pulseaudio
, libxshmfence
, libnotify
, libappindicator-gtk3
, wrapGAppsHook
, autoPatchelfHook
}:

let

  pname = "mattermost-desktop";
  version = "5.3.1";

  srcs = {
    "x86_64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
      hash = "sha256-rw+SYCFmN2W4t5iIWEpV9VHxcvwTLOckMV58WRa5dZE=";
    };

    "aarch64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-arm64.tar.gz";
      hash = "sha256-FEIldkb3FbUfVAYRkjs7oPRJDHdsIGDW5iaC2Qz1dpc=";
    };
  };

  inherit (stdenv.hostPlatform) system;

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl (srcs."${system}" or (throw "Unsupported system ${system}"));

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;

  nativeBuildInputs = [ wrapGAppsHook autoPatchelfHook ];

  buildInputs = atomEnv.packages ++ [
    libxshmfence
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    pulseaudio
    libnotify
    libappindicator-gtk3
  ];

  installPhase = ''
    runHook preInstall

    # Mattermost tarball comes with executable bit set for everything.
    # We’ll apply it only to files that need it.
    find . -type f -print0 | xargs -0 chmod -x
    find . -type f \( -name '*.so.*' -o -name '*.s[oh]' \) -print0 | xargs -0 chmod +x
    chmod +x mattermost-desktop chrome-sandbox

    mkdir -p $out/share/mattermost-desktop
    cp -R . $out/share/mattermost-desktop

    mkdir -p "$out/bin"
    ln -s $out/share/mattermost-desktop/mattermost-desktop $out/bin/mattermost-desktop

    patchShebangs $out/share/mattermost-desktop/create_desktop_file.sh
    $out/share/mattermost-desktop/create_desktop_file.sh
    rm $out/share/mattermost-desktop/create_desktop_file.sh
    mkdir -p $out/share/applications
    chmod -x Mattermost.desktop
    mv Mattermost.desktop $out/share/applications/Mattermost.desktop
    substituteInPlace $out/share/applications/Mattermost.desktop \
      --replace /share/mattermost-desktop/mattermost-desktop /bin/mattermost-desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mattermost Desktop client";
    homepage = "https://about.mattermost.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = [ maintainers.joko ];
  };
}

{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "trunk-io";
  version = "1.2.4";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${version}/trunk";
    hash = "sha256-ylQ4tcPVO367PtLtBkw+MKxoIY7b14Gse3IxnIxMtqc=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/trunk
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://trunk.io/";
    description = "Developer experience toolkit used to check, test, merge, and monitor code";
    license = licenses.unfree;
    maintainers = with maintainers; [ aaronjheng ];
  };
}

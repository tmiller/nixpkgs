{ lib
, stdenv
, fetchFromGitHub
, pkg-config

, gtk3
, curl
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "smooth";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "smooth";
    rev = "v${version}";
    sha256 = "sha256-J2Do1iAbE1GBC8co/4nxOzeGJQiPRc+21fgMDpzKX+A=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  buildInputs = [
    gtk3
    curl
    libxml2
  ];

  meta = with lib; {
    description = "The smooth Class Library";
    license = licenses.artistic2;
    homepage = "http://www.smooth-project.org/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}

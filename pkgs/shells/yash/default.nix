{ stdenv, lib, fetchurl, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.54";

  src = fetchurl {
    url = "https://osdn.net/dl/yash/yash-${version}.tar.xz";
    hash = "sha256-RKCsHM98Os7PvqAn2MDJMPE6goBlvjGAVc4RMBU5GDk=";
  };

  strictDeps = true;
  buildInputs = [ gettext ncurses ];

  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}

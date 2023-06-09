{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "easeprobe";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "megaease";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z+qwmVsznzm6TjvDOT1/8Zy3wUDPFDrjcpxXXHnb4oo=";
  };

  vendorHash = "sha256-N32uSuHAbTfGg+Y1bmngzw4RTx5gR4DGKbSBB0BT+8I=";

  subPackages = [ "cmd/easeprobe" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
    "-X github.com/megaease/easeprobe/global.Ver=${version}"
    "-X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe"
  ];

  meta = with lib; {
    description = "A simple, standalone, and lightweight tool that can do health/status checking, written in Go";
    homepage = "https://github.com/megaease/easeprobe";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

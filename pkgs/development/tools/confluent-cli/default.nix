{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "confluent-cli";
  version = "3.17.0";

  # To get the latest version:
  # curl -L https://cnfl.io/cli | sh -s -- -l | grep -v latest | sort -V | tail -n1
  src = fetchurl (if stdenv.hostPlatform.isDarwin then {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${version}/confluent_${version}_darwin_amd64.tar.gz";
      sha256 = "03104736f65591a5be9536424460d9b8c8fc8ac8b5eb646e832371397aaf7cef";
    } else {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${version}/confluent_${version}_linux_amd64.tar.gz";
      sha256 = "3243beca4fefd49cf067f9a4df4f5072a8ac5dac91638e9f10ef0b0544d30445";
    });

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontStrip = stdenv.isDarwin;

  installPhase = ''
    mkdir -p $out/{bin,share/doc/confluent-cli}
    cp confluent $out/bin/
    cp LICENSE $out/share/doc/confluent-cli/
    cp -r legal $out/share/doc/confluent-cli/
  '';

  meta = with lib; {
    description = "Confluent CLI";
    homepage = "https://docs.confluent.io/confluent-cli/current/overview.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ rguevara84 ];

    # TODO: There's support for i686 systems but I do not have any such system
    # to build it locally on, it's also unfree so I cannot rely on ofborg to
    # build it. Get the list of supported system by looking at the list of
    # files in the S3 bucket:
    #
    #   https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=confluent-cli/archives/1.25.0/&delimiter=/%27
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

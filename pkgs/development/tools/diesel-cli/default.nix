{ lib
, sqliteSupport ? true
, postgresqlSupport ? true
, mysqlSupport ? true
, rustPlatform
, fetchCrate
, installShellFiles
, pkg-config
, openssl
, stdenv
, Security
, libiconv
, sqlite
, postgresql
, mariadb
, zlib
}:

assert lib.assertMsg (sqliteSupport == true || postgresqlSupport == true || mysqlSupport == true)
  "support for at least one database must be enabled";

let
  inherit (lib) optional optionals optionalString;
in

rustPlatform.buildRustPackage rec {
  pname = "diesel-cli";
  version = "2.1.0";

  src = fetchCrate {
    inherit version;
    crateName = "diesel_cli";
    hash = "sha256-FdmjfywvDD3mo1d1pUQMYvebo5AUTa99gQbQuOWmZZk=";
  };

  cargoHash = "sha256-onPzM9E53VUogZdIu3jAeB4dL3MC2FP3b6QWZ5Tr3j0=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ]
    ++ optional stdenv.isDarwin Security
    ++ optional (stdenv.isDarwin && mysqlSupport) libiconv
    ++ optional sqliteSupport sqlite
    ++ optional postgresqlSupport postgresql
    ++ optionals mysqlSupport [ mariadb zlib ];

  buildNoDefaultFeatures = true;
  buildFeatures = optional sqliteSupport "sqlite"
    ++ optional postgresqlSupport "postgres"
    ++ optional mysqlSupport "mysql";

  checkPhase = ''
    runHook preCheck
  '' + optionalString sqliteSupport ''
    cargo check --features sqlite
  '' + optionalString postgresqlSupport ''
    cargo check --features postgres
  '' + optionalString mysqlSupport ''
    cargo check --features mysql
  '' + ''
    runHook postCheck
  '';

  postInstall = ''
    installShellCompletion --cmd diesel \
      --bash <($out/bin/diesel completions bash) \
      --fish <($out/bin/diesel completions fish) \
      --zsh <($out/bin/diesel completions zsh)
  '';

  # Fix the build with mariadb, which otherwise shows "error adding symbols:
  # DSO missing from command line" errors for libz and libssl.
  NIX_LDFLAGS = optionalString mysqlSupport "-lz -lssl -lcrypto";

  meta = with lib; {
    description = "Database tool for working with Rust projects that use Diesel";
    homepage = "https://github.com/diesel-rs/diesel/tree/master/diesel_cli";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ];
    mainProgram = "diesel";
  };
}

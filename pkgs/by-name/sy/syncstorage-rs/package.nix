{ fetchFromGitHub
, rustPlatform
, pkg-config
, python3
, cmake
, libmysqlclient
, makeBinaryWrapper
, lib
}:

let
  pyFxADeps = python3.withPackages (p: [
    p.setuptools # imports pkg_resources
    # remainder taken from requirements.txt
    p.pyfxa
    p.tokenlib
    p.cryptography
  ]);
in

rustPlatform.buildRustPackage rec {
  pname = "syncstorage-rs";
  version = "0.17.9";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ezTwAAtt0/jKfA6FtvzuQVFYOODMcD4RFiU3x0Umifk=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    libmysqlclient
  ];

  preFixup = ''
    wrapProgram $out/bin/syncserver \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "deadpool-0.7.0" = "sha256-yQwn45EuzmPBwuT+iLJ/LLWAkBkW2vF+GLswdbpFVAY=";
    };
  };

  # almost all tests need a DB to test against
  doCheck = false;

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    changelog = "https://github.com/mozilla-services/syncstorage-rs/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "syncserver";
  };
}

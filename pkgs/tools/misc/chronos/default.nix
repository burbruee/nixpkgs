{ lib
, stdenv
, rustPlatform
, fetchgit
}:

rustPlatform.buildRustPackage rec {
  pname = "chronos";
  version = "0.3.0";

  src = fetchgit {
    name = "chronos";
    url = "https://github.com/DarkRTA/chronos";
    rev = "8cdffa279e5fdaa5a542fe09500db52b22965f20";
    sha256 = "sha256-XcIUHA+inlsZ0YfKAYeTpEJxDePMA0LH81aCGwVrdjA=";
    fetchSubmodules = "livesplit-core";
  };

  cargoHash = "sha256-6F2sD5DNW6RnEQSwRfyEKbqSEWOAUOCc8w1NEx/WWHo=";

  meta = with lib; {
    description = "chronos is a lightweight speedrun timer that runs in your terminal.";
    license = licenses.mit;
    maintainers = with maintainers; [ burbruee ];
    homepage = "https://github.com/DarkRTA/chronos";
    platforms = platforms.unix;
    mainProgram = "chronos";
    broken = stdenv.hostPlatform.isDarwin;
  };
}


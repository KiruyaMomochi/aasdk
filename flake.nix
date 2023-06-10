{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages.default = pkgs.callPackage
          (
            { stdenv
            , lib
            , cmake
            , libusb
            , openssl
            , protobuf
            , boost
            }:
            stdenv.mkDerivation {
              pname = "aasdk";
              version = "crankshaft-ng";

              src = ./.;

              nativeBuildInputs = [ cmake boost ];
              buildInputs = [ libusb protobuf openssl ];

              # https://github.com/cidkidnix/nixcfg/blob/master/machines/cfg/packages/aasdk/default.nix
              cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];
            }
          )
          { };

        devShells.default = pkgs.mkShell {
          packages = (with pkgs; [
            cmake
            boost
            protobuf
            libusb
            openssl
          ]);
        };
      });
}

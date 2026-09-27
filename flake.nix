# flake.nix
{
  description = "Anycubic Slicer Next NixOS Package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # Uygulamanın ihtiyaç duyduğu kütüphaneler
        appDependencies = with pkgs; [
          glib
          glib-networking
          gtk3
          libGL
          libX11
          libXext
          libXrender
          libXinerama
          libXrandr
          libXcursor
          libXi
          zlib
          fontconfig
          pango
          cairo
          libglvnd
          webkitgtk_4_1
          libsoup_3
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          libpsl
        ];
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "anycubic-slicer-next";

          src = pkgs.fetchurl {
            url = "https://cdn-universe-slicer.anycubic.com/prod/pool/main/a/anycubicslicernext/AnycubicSlicerNext_linux-v2.0.0.5-20260913065625.deb";
            sha256 = "fe087a56014ed25cdfe4c3c293b517adaee0a9b2e1ded79f5e394b7968817c15";
          };

          nativeBuildInputs = [pkgs.dpkg pkgs.autoPatchelfHook];
          buildInputs = appDependencies;

          postFixup = ''
            expected_interpreter=$(cat "$NIX_CC/nix-support/dynamic-linker")
            patchelf --set-interpreter "$expected_interpreter" \
              --set-rpath "${pkgs.lib.makeLibraryPath appDependencies}" \
              "$out/bin/anycubic"

            actual_interpreter=$(patchelf --print-interpreter "$out/bin/anycubic")
            if [ "$actual_interpreter" != "$expected_interpreter" ]; then
              echo "Unexpected ELF interpreter: $actual_interpreter (expected $expected_interpreter)" >&2
              exit 1
            fi
          '';

          installPhase = ''
            # .deb dosyasını çıkar
            mkdir -p $out
            dpkg -x $src $out/
            ln -s usr/share/AnycubicSlicerNext/resources "$out/resources"

            # Binary dosyasını bul
            BINARY_PATH=$(find $out -type f -executable -name "*anycubic*" | head -n 1)
            if [ -z "$BINARY_PATH" ]; then
              BINARY_PATH=$(find $out -type f -executable | head -n 1)
            fi

            if [ -n "$BINARY_PATH" ]; then
              mkdir -p $out/bin
              cp "$BINARY_PATH" $out/bin/anycubic
            else
              echo "Hata: anycubicslicernext binary dosyası bulunamadı"
              exit 1
            fi
          '';

          meta = {
            description = "Anycubic Slicer Next";
            homepage = "https://anycubic.com";
            license = pkgs.lib.licenses.unfree;
            maintainers = with pkgs.lib.maintainers; [];
            platforms = pkgs.lib.platforms.linux;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [];
          shellHook = ''
            echo "-------------------------------------------------------"
            echo "Anycubic Slicer NixOS Ortamı Hazır."
            echo "Çalıştırmak için: ./result/bin/anycubic"
            echo "-------------------------------------------------------"
          '';
        };
      }
    );
}

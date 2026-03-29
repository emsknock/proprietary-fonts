{
	inputs.nixpkgs.url = "github:nixos/nixpkgs";
	outputs = inputs: let
		system = "x86_64-linux";
		font = ["mono-lisa"];
		pkgs = import inputs.nixpkgs {inherit system;};
		make = font-name: {
			lib,
			stdenv,
			unzip,
			age,
			writeTextFile,
			key ? null,
			...
		}:
			stdenv.mkDerivation {
				pname = font-name;
				version = "1.000";

				src = ./data/${font-name}.zip.age;

				buildInputs = [unzip age];

				unpackPhase =
					# NOTE: It might feel logical to put these before the `mkDerivation`
					#       call but that makes `package.override` uncallable since to
					#       access `package.override` nix has to evaluate `package`.
					assert lib.strings.isString key;
					assert lib.strings.hasInfix "AGE-SECRET-KEY" key; let
						age-identity =
							writeTextFile {
								name = "font-decrypt-key";
								text = key;
							};
					in ''
						runHook preUnpack

						age                            \
							--decrypt                  \
							--identity=${age-identity} \
							--output=font.zip          \
							$src
						unzip font.zip

						runHook postUnpack
					'';

				installPhase = ''
					runHook preInstall

					install -D                                       \
						--mode=644                                   \
						--target-directory=$out/share/fonts/truetype \
						data/${font-name}/*.ttf

					runHook postInstall
				'';
			};
	in {
		packages.${system} = pkgs.lib.genAttrs font (name: pkgs.callPackage (make name) {});
		devShells.${system}.default =
			pkgs.mkShell {
				packages = [
					pkgs.just
					pkgs.zip
					pkgs.unzip
					pkgs.age
				];
			};
	};
}

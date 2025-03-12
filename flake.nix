{
  description = "CLI for fabric";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation rec {
            name = "fabric-cli";
            src = self;
            outputs = [ "out" "dev" ];

            nativeBuildInputs = with pkgs; [ meson ninja pkg-config ];
            buildInputs = with pkgs; [ ];

            enableParallelBuilding = true;

            phases = ["installPhase"];
            installPhase = ''
              mkdir -p $out/bin
              cat > $out/bin/fabric-cli << EOF
              #!/bin/sh
              meson setup --buildtype=release --prefix=/usr build && sudo meson install -C build
              EOF
              chmod +x $out/bin/fabric-cli
            '';
            meta = with pkgs.lib; {
              homepage = "https://wiki.ffpy.org/getting-started/client-and-cli/";
              license = with licenses; [ gpl3Only ];
              maintainers = [ "Kyu~" ];
              mainProgram = "fabric-cli";
            };
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              meson
              ninja
              pkg-config
            ];

            # shellHooks = ''
            #   # export PATH="$PWD/node_modules/.bin/:$PATH"
            #   alias run="meson setup --buildtype=release --prefix=/usr build && sudo meson install -C build"
            # '';
          };
        });
    };
}

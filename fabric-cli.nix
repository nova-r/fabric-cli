{
  meson,
  ninja,
  go,
  stdenv,
  extraBuildInputs ? [],
}:
let
  python = "bll";
in
  stdenv.mkDerivation {
    name = "fabric-cli";
    propagatedBuildInputs =
      [
        meson
        ninja
        go
      ]
      ++ extraBuildInputs;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      # cat > $out/bin/run-widget << EOF
      # #!/bin/sh
      # GI_TYPELIB_PATH=$GI_TYPELIB_PATH \
      # GDK_PIXBUF_MODULE_FILE="$GDK_PIXBUF_MODULE_FILE" \
      # ${python.interpreter} "\$@"
      # EOF
      meson setup --buildtype=release --prefix=/usr build && sudo meson install -C build
    '';
    meta.mainProgram = "fabric-cli";
  }

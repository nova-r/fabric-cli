{
  meson,
  ninja,
  go,
  stdenv,
  extraBuildInputs ? []
}:
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
      # {python.interpreter} "\$@"
      # EOF
      echo $out
      echo $src
      echo $NIX_BUILD_TOP
      ${meson}/bin/meson setup --buildtype=release --prefix=/usr $NIX_BUILD_TOP #&& sudo ${meson}/bin/meson install -C $out/build
    '';
    meta.mainProgram = "fabric-cli";
  }

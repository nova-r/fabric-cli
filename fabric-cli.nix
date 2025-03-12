{
  meson,
  ninja,
  go,
  fetchFromGitHub,
  stdenv,
  extraBuildInputs ? []
}:
  stdenv.mkDerivation {
    name = "fabric-cli";
    src = fetchFromGitHub {
      owner = "HeyImKyu";
      repo = "fabric-cli";
      rev = "ed7da8aeed726abb9cb0603efa83b693b91d3159";
      hash = "sha256-NatSzI0vbUxwvrUQnTwKUan0mZYJpH6oyCRaEr0JCB0=";
    };
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
      

    # Print debug information
      echo "Source directory: $src"
      echo "Build directory: $NIX_BUILD_TOP"
      echo "out: $out"
      echo "eodebug ---------------"

      # Run meson setup
      ${meson}/bin/meson setup $src $out/build --buildtype=release --prefix=$out 
      ${meson}/bin/meson install -C $out/build
      # echo $out
      # echo $src
      # echo $NIX_BUILD_TOP
      # ${meson}/bin/meson setup --buildtype=release --prefix=/usr {src} #&& sudo {meson}/bin/meson install -C $out/build
    '';
    meta.mainProgram = "fabric-cli";
  }

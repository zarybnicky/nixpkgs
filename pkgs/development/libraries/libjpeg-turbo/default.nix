{ stdenv, fetchurl, cmake, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "1zv6z093l3x3jzygvni7b819j7xhn6d63jhcdrckj7fz67n6ry75";
  };

  patches =
    stdenv.lib.optional (stdenv.hostPlatform.libc or null == "msvcrt")
      ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ cmake nasm ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DCMAKE_INSTALL_BINDIR=$bin/bin"
      "-DENABLE_STATIC=0"
    )
  '';

  doCheck = true; # not cross;
  checkTarget = "test";
  preCheck = ''
    export LD_LIBRARY_PATH="$NIX_BUILD_TOP/${name}:$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.all;
  };
}

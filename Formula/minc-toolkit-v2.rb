class MincToolkitV2 < Formula
  desc "MINC medical image processing toolkit (full build)"
  homepage "https://github.com/BIC-MNI/minc-toolkit-v2"
  # Pinned to the develop-1.9.18 branch tip. A git checkout is required (not a
  # release tarball) because the ~30 in-tree components are git submodules that
  # must be present before configure; Homebrew's git strategy checks them out
  # recursively. Bump `revision` (and any changed resources below) when the
  # branch advances.
  # `branch:` is required alongside `revision:` so Homebrew fetches develop-1.9.18
  # (not the repo's default branch); otherwise the pinned commit is not in the
  # shallow clone and checkout fails with "unable to read tree".
  url "https://github.com/BIC-MNI/minc-toolkit-v2.git",
      branch:   "develop-1.9.18",
      revision: "69c133b332f5b3602d327ced86e3da7e07879a60"
  version "1.9.18-20260305" # MINC_TOOLKIT_VERSION_FULL in CMakeLists.txt
  license "GPL-3.0-only"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "glfw"        # visual tools use the GLFW/Cocoa backend on Apple
  depends_on "libarchive"  # replaces the build-time libarchive fetch
  depends_on "libpng"      # USE_SYSTEM_PNG (auto-on on Apple Silicon)
  depends_on "openblas"    # BLAS_PREFERENCE=OpenBLAS (Accelerate lacks LAPACKE)
  depends_on "perl"        # many tools are Perl scripts

  # ---------------------------------------------------------------------------
  # Pre-cached third-party tarballs.
  #
  # The superbuild fetches these at CONFIGURE time via file(DOWNLOAD ...
  # EXPECTED_MD5 ...) into MT_PACKAGES_PATH. file(DOWNLOAD) skips the network
  # when the target file already exists with the matching hash, so we stage each
  # tarball into the cache with the exact filename GET_PACKAGE expects (see
  # RESOURCE_FILES). Every sha256 below corresponds to a tarball whose MD5
  # matches the value hard-coded in cmake-modules/Build*.cmake, so the offline
  # skip actually triggers and the install phase needs no network.
  # ---------------------------------------------------------------------------
  resource "zlib-ng" do
    url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.3.tar.gz"
    sha256 "f9c65aa9c852eb8255b636fd9f07ce1c406f061ec19a2e7d508b318ca0c907d1"
  end

  resource "netcdf" do
    url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz"
    sha256 "99930ad7b3c4c1a8e8831fb061cb02b2170fc8e5ccaeda733bd99c3b9d31666b"
  end

  resource "hdf5" do
    url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/src/hdf5-1.12.1.tar.bz2"
    sha256 "aaf9f532b3eda83d3d3adc9f8b40a9b763152218fa45349c3bc77502ca1f8f1c"
  end

  resource "nifti" do
    url "https://github.com/NIFTI-Imaging/nifti_clib/archive/refs/tags/v3.0.0.tar.gz"
    sha256 "fe6cb1076974df01844f3f4dab1aa844953b3bc1d679126c652975158573d03d"
  end

  resource "openjpeg" do
    url "https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.4.tar.gz"
    sha256 "a695fbe19c0165f295a8531b1e4e855cd94d0875d2f88ec4b61080677e27188a"
  end

  resource "jpeg-turbo" do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.4.1/libjpeg-turbo-3.1.4.1.tar.gz"
    sha256 "ecae8008e2cc9ade2f2c1bb9d5e6d4fb73e7c433866a056bd82980741571a022"
  end

  resource "gsl" do
    url "https://ftpmirror.gnu.org/gnu/gsl/gsl-2.4.tar.gz"
    sha256 "4d46d07b946e7b31c19bbf33dda6204d7bedc2f5462a1bae1d4013426cd1ce9b"
  end

  resource "fftw" do
    url "https://fftw.org/fftw-3.3.11.tar.gz"
    sha256 "5630c24cdeb33b131612f7eb4b1a9934234754f9f388ff8617458d0be6f239a1"
  end

  resource "liblbfgs" do
    url "https://github.com/chokkan/liblbfgs/archive/5ad02fbefefdeff339ab03635e673571055a0644.tar.gz"
    sha256 "5bb29a5b0fbfe2f4d6f48e92a6913e7634716eb240f42384b92d3a9fc405648b"
  end

  resource "itk" do
    url "https://github.com/InsightSoftwareConsortium/ITK/archive/cae3eb95758e70ff879f3ab5d3cbd5a764d70cf9.tar.gz"
    sha256 "c041d7f06e88bb8dcf46a833bff179334dc3fd8a5931ccb0e0e2f0ae200292b8"
  end

  resource "c3d" do
    url "https://github.com/vfonov/Convert3D/archive/refs/tags/v0.1.tar.gz"
    sha256 "7bc384a9beb5c48a61f8f103234c7e25c027d8e2d593e9b9959289ae7a356d01"
  end

  resource "elastix" do
    url "https://github.com/vfonov/elastix/archive/4a561ff4861b494b4d64f642601950001c8c90d5.tar.gz"
    sha256 "46640f6e47704209246f616ecd0171cbe70b53267c5e82e387b5b534ce1bfd3b"
  end

  resource "abc" do
    url "https://github.com/vfonov/abc/archive/refs/tags/ABC-REL1.4.2-minc.tar.gz"
    sha256 "165749a33860f33ad2e685e408006c1c507804263cc4b76e4f12dd9f5e15c902"
  end

  # Homebrew resource name => filename the matching GET_PACKAGE() call expects
  # in MT_PACKAGES_PATH (3rd argument in cmake-modules/Build*.cmake).
  RESOURCE_FILES = {
    "zlib-ng"    => "zlib-ng-2.3.3.tar.gz",
    "netcdf"     => "netcdf-v4.7.4.tar.gz",
    "hdf5"       => "hdf5-1.12.1.tar.bz2",
    "nifti"      => "nifti_clib-3.0.0.tar.gz",
    "openjpeg"   => "openjpeg-2.5.4.tar.gz",
    "jpeg-turbo" => "libjpeg-turbo-3.1.4.1.tar.gz",
    "gsl"        => "gsl-2.4.tar.gz",
    "fftw"       => "fftw-3.3.11.tar.gz",
    "liblbfgs"   => "liblbfgs-5ad02fb.tar.gz",
    "itk"        => "InsightToolkit-4.14-cae3eb9.tar.gz",
    "c3d"        => "c3d-v0.1.tar.gz",
    "elastix"    => "elastix-4a561ff4.tar.gz",
    "abc"        => "ABC-REL1.4.2-minc.tar.gz",
  }.freeze

  def install
    # Stage the pre-fetched tarballs (raw, unextracted) into the package cache
    # so the configure-time file(DOWNLOAD) calls hit the local copies. Copying
    # cached_download avoids Homebrew's default extraction.
    cache = buildpath/"pkgcache"
    cache.mkpath
    RESOURCE_FILES.each do |res, fname|
      cp resource(res).cached_download, cache/fname
    end

    # Keg-only / to-be-discovered deps that FindBLAS and the USE_SYSTEM_*
    # finders need on CMAKE_PREFIX_PATH.
    prefix_path = [
      formula_opt_prefix("openblas"),
      formula_opt_prefix("libarchive"),
      formula_opt_prefix("libpng"),
      formula_opt_prefix("glfw"),
    ].join(";")

    args = %W[
      -DMT_PACKAGES_PATH=#{cache}
      -DCMAKE_PREFIX_PATH=#{prefix_path}
      -DMT_BUILD_LITE=OFF
      -DMT_BUILD_ITK_TOOLS=ON
      -DMT_BUILD_ANTS=ON
      -DMT_BUILD_C3D=ON
      -DMT_BUILD_ELASTIX=ON
      -DMT_BUILD_ABC=ON
      -DMT_BUILD_VISUAL_TOOLS=ON
      -DMT_BUILD_SHARED_LIBS=ON
      -DMT_USE_BLAS=ON
      -DBLAS_PREFERENCE=OpenBLAS
      -DUSE_SYSTEM_LIBARCHIVE=ON
      -DUSE_SYSTEM_PNG=ON
      -DMT_USE_OPENMP=OFF
      -DBUILD_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  def caveats
    <<~EOS
      Source the environment before using the tools (sets PATH, PERL5LIB,
      DYLD_LIBRARY_PATH, MNI_DATAPATH, MINC_FORCE_V2, ...):
        source #{opt_prefix}/minc-toolkit-config.sh
    EOS
  end

  test do
    # minc-toolkit-config.sh wires up runtime paths; call binaries directly.
    assert_match "mincinfo", shell_output("#{bin}/mincinfo -help 2>&1", 1)
    system bin/"mincstats", "-version"
  end
end

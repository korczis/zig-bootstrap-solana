{
  description = "A flake for Solana development with Zig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  nixConfig.bash-prompt-suffix = "(zig-solana) ";
  
  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem(system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cmake
            gdb
            ninja
            qemu
            wasmtime
            openssl.dev
            udev
            python3
            pkg-config
          ] ++ (with llvmPackages_13; [
            clang
            clang-unwrapped
            lld
            llvm
          ]);

          hardeningDisable = [ "all" ];
        };
      }
  );
}

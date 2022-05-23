{
  description = "A flake for Zig development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  nixConfig.bash-prompt-suffix = "(zig) ";

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
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
           ] ++ (with llvmPackages_13; [
             clang
             clang-unwrapped
             lld
             llvm
           ]);

           hardeningDisable = [ "all" ];
           shellHook = "export PATH=$PATH:~/zig/build";
         };
      }
  );
}

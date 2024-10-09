{ pkgs ? import <nixpkgs> { } }:
let elixir = (pkgs.beam.packagesWith pkgs.erlang_26).elixir_1_16;
in pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.erlang_26
    elixir
  ];
}

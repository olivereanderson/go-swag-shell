{
  description = "go-swag with goReference";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ utils.lib.system.x86_64-linux ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          # Make sure our shell has the same go that built go-swag
          # We do this by "redefining" buildGoModule to take our go
          # and then redefine go-swag to take our redefined buildGoModule
          go = pkgs.go;
          buildGoModule = pkgs.buildGoModule.override {inherit go;};
          # We will also make sure go-swag gets built with allowGoReference=true
          go-swag = (pkgs.go-swag.override {inherit buildGoModule; }).overrideAttrs {allowGoReference=true;};
        in
        {
          # `nix develop`
          devShells.default = pkgs.mkShell {
            packages = [
              go
              go-swag
            ];
            # shellHook = ''
            # '';
          };
        }
      );
}

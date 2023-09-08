{ inputs
, self
, withSystem
, sharedModules
, desktopModules
, homeImports
, ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({ system, ... }: {
    legion = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [

          ./legion
          ../modules/doas.nix
          ../modules/xserver.nix
          ../modules/hyprland.nix
          ../modules/security.nix
          ../modules/desktop.nix

          { home-manager.users.clementf.imports = homeImports."clementf@legion"; }
        ]
        ++ sharedModules
        ++ desktopModules;
    };
  });
}

{ inputs
, self
, withSystem
, module_args
, ...
}:
let
  sharedModules = [
    ../.
    ../shells
    module_args
  ];

  desktopModules = with inputs; [
    hyprland.homeManagerModules.default
    ../wayland
  ];

  homeImports = {
    "clementf@legion" =
      sharedModules
      ++ desktopModules
      ++ [ ./legion ];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in
{
  imports = [
    { _module.args = { inherit homeImports; }; }
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({ pkgs, ... }: {
      "clementf@legion" = homeManagerConfiguration {
        modules = homeImports."clementf@legion" ++ module_args;
        inherit pkgs;
      };
    });
  };
}

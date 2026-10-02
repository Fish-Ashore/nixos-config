{
  description = "我的 NixOS 配置，带 Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-26_05.url = "github:NixOS/nixpkgs/nixos-26.05";

    mark-shot = {
      url = "github:jswysnemc/mark-shot";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elegant-grub2-themes = {
      url = "github:vinceliuice/elegant-grub2-themes";
    };

    rproc = {
      url = "github:trystan-sa/rproc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # tuxManager = {
    #   url = "github:benapetr/TuxManager/";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      elegant-grub2-themes,
      ...
    }@inputs:
    let
      pkgsFor26 =
        system:
        import inputs.nixpkgs-26_05 {
          inherit system;
          config.allowUnfree = true;
          overlays = [ inputs.nur.overlays.default ];
        };
    in
    {
      nixosConfigurations.hy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgsStable = pkgsFor26 "x86_64-linux";
        };
        modules = [
          ./configuration.nix
          ./noctalia-greeder.nix
          elegant-grub2-themes.nixosModules.default
          home-manager.nixosModules.home-manager
          ./home.nix
        ];
      };
    };
}

{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Tools
    pavucontrol
    networkmanagerapplet
    thunderbird
    blueberry

    # Dev
    maven
    jdk
    jd-gui
    jetbrains.idea-ultimate
    jetbrains.rider
    jetbrains-toolbox
    poetry
    dotnet-sdk_7
    mono

    # Fonts
    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" "Iosevka" ];
    })

    # Productivity
    flameshot
    xfce.thunar
    (pkgs.discord.override {
      #withOpenASAR = true;
      withVencord = true;
    })
    termius
    postman
    parsec-bin

    # Fun
    spotify
  ];
}

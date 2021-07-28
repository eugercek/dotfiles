{ config, pkgs, ... }:

{
  imports =
    [./hardware-configuration.nix
    ];

  # EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #-------------VM----------------------
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.checkJournalingFS = false;
  #-------------------------------------

  networking.hostName = "umut"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant. TODO

  time.timeZone = "Turkey";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  # TODO Add wireless DHCP = true too

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services.xserver.enable = true;

  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  users.users.umut = {
    isNormalUser = true;
    home = "/home/umut";
    description = "Emin Umut Gercek";
    extraGroups = [ "wheel" "networkmanager"];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "21.05";

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.useGlamor = true; # TODO Recommended by manual

  services.xserver.videoDrivers = [ "nvidia" ];

  #GNOME
  services.xserver.displayManager.gdm.enable = true;
  # services.gnome.core-utilities.enable = false;
}

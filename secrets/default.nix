# NixOS module
{
  age.secrets = {
    nftables.file = ./lux/nftables.age;
    vaultwarden.file = ./lux/vaultwarden.age;
  };
}

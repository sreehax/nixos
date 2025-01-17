# NixOS module
{
  age.secrets = {
    "nftables".file = ./nftables.age;
    "vaultwarden".file = ./vaultwarden.age;
  };
}

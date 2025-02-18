{ config, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://auth.ssree.dev";
      #SIGNUPS_ALLOWED = false;
      PUSH_ENABLED = true;
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };
}

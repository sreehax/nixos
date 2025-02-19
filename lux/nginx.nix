{ inputs, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts."origin.ssree.dev" = {
      # Let nginx render our blog...
      forceSSL = true;
      enableACME = true;
      locations."/".root = inputs.site.packages.${pkgs.system}.web;
      extraConfig = ''
        error_page 404 /404.html;
      '';
    };
    virtualHosts."mta-sts.ssree.dev" = {
      addSSL = true;
      enableACME = true;
      root = "/mnt/data/mail/mta-sts";
    };
    virtualHosts."mta-sts.hisonly.fans" = {
      addSSL = true;
      enableACME = true;
      root = "/mnt/data/mail/mta-sts";
    };
    virtualHosts."luxembourg.ssree.dev" = {
      addSSL = true;
      enableACME = true;
      root = "/mnt/data/public_web";
    };
    virtualHosts."origin.frostium.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/".root = inputs.site.packages.${pkgs.system}.web;
      extraConfig = ''
        error_page 404 /404.html;
      '';

    };
    virtualHosts."mta-sts.diabolicalbigblack.wang" = {
      addSSL = true;
      enableACME = true;
      root = "/mnt/data/mail/mta-sts";
    };
    virtualHosts."auth.ssree.dev" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 1000M;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
        proxyWebsockets = true;
      };
    };
    virtualHosts."cse412-backend.ssree.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:6969";
        proxyWebsockets = true;
      };
    };
    virtualHosts."diabolicalbigblack.wang" = {
      forceSSL = true;
      enableACME = true;
      root = "/mnt/data/diabolicalbigblack.wang";
    };
    virtualHosts."hisonly.fans" = {
      forceSSL = true;
      enableACME = true;
      root = "/mnt/data/hisonly.fans";
    };
  };
}

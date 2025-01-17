{
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = [ "192.168.42.1/24" ];
        listenPort = 12345;
        privateKeyFile = "/etc/wg/server.key";

        peers = [
          {
            publicKey = "7sTbKcaLkD1hiYfVRPew7YEQQPdvpLZhQyaCs/3Dyi0=";
            allowedIPs = [ "192.168.42.2/32" ];
          }
        ];
      };
    };
  };
}

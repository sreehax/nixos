{
  listenPort = 12345;
  ips = [ "10.42.1.1/24" ];
  privateKeyFile = "/etc/wireguard/server.key";

  peers = [
    { # Macbook
      publicKey = "GXiyC6hs1ehfxJxk2A4HZprW7ahebFwm2Q3Sl1wG+wc=";
      allowedIPs = [ "10.42.1.2/32" ];
    }
    { # iPhone
      publicKey = "0LF+QiEDFjk4l9D8ab8y2iAKI/rFQGoXJk3Frtx89HQ=";
      allowedIPs = [ "10.42.1.3/32" ];
    }
  ];
}

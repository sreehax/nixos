{
  services.nsd = {
    interfaces = [
      "104.244.76.122"
      "2605:6400:30:f9a2::2"
    ];
    enable = true;
    hideVersion = true;
    identity = "ns3.ssree.dev";
    zonefilesCheck = false;
    keys = {
      "lux_key" = {
        algorithm = "hmac-sha256";
        keyFile = "/etc/lux_key";
      };
    };
    zones = {
      "ssree.dev" = {
        data = "ssree.dev. 3600 IN SOA ns1.ssree.dev. admin.ssree.dev. 1970010101 10000 2400 604800 3600";
        outgoingInterface = "104.244.76.122";
        allowNotify = [
          "185.44.83.60 lux_key"
          "127.0.0.1 NOKEY"
        ];
        requestXFR = [
          "AXFR 185.44.83.60 lux_key"
        ];
      };
      "diabolicalbigblack.wang" = {
        data = "diabolicalbigblack.wang. 3600 IN SOA ns1.ssree.dev. admin.ssree.dev. 1970010101 10000 2400 604800 3600";
        outgoingInterface = "104.244.76.122";
        allowNotify = [
          "185.44.83.60 lux_key"
          "127.0.0.1 NOKEY"
        ];
        requestXFR = [
          "AXFR 185.44.83.60 lux_key"
        ];
      };
      "sydney.blue" = {
        data = "sydney.blue. 3600 IN SOA ns1.ssree.dev. admin.ssree.dev. 1970010101 10000 2400 604800 3600";
        outgoingInterface = "104.244.76.122";
        allowNotify = [
          "185.44.83.60 lux_key"
          "127.0.0.1 NOKEY"
        ];
        requestXFR = [
          "AXFR 185.44.83.60 lux_key"
        ];
      };
      "8.3.1.c.f.d.5.0.a.2.ip6.arpa" = {
        data = "8.3.1.c.f.d.5.0.a.2.ip6.arpa. 3600 IN SOA ns1.ssree.dev. admin.ssree.dev. 1970010101 10000 2400 604800 3600";
        outgoingInterface = "104.244.76.122";
        allowNotify = [
          "185.44.83.60 lux_key"
          "127.0.0.1 NOKEY"
        ];
        requestXFR = [
          "AXFR 185.44.83.60 lux_key"
        ];
      };
    };
  };
}

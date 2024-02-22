{
  interfaces-config = {
    interfaces = [
      "br0"
    ];
  };

  lease-database = {
    type = "memfile";
    persist = true;
    name = "/var/lib/kea/dhcp4.leases";
  };

  valid-lifetime = 28800;

  option-data = [
    {
      name = "domain-name-servers";
      data = "10.69.0.1, 9.9.9.9";
    }
  ];

  subnet4 = [
    {
      subnet = "10.69.0.0/16";
      pools = [
        {
	  pool = "10.69.1.1 - 10.69.254.200";
	}
      ];
      option-data = [
        {
	  name = "routers";
	  data = "10.69.0.1";
	}
      ];
      reservations = [
        {
	  hw-address = "00:1c:c2:4d:10:9f";
	  ip-address = "10.69.0.5";
	}
	{
	  hw-address = "74:56:3c:72:6b:b2";
	  ip-address = "10.69.0.3";
	}
	{
	  hw-address = "ac:15:a2:6c:01:3a";
	  ip-address = "10.69.0.2";
	}
	{
	  hw-address = "74:8f:3c:b8:8e:73";
	  ip-address = "10.69.0.4";
	}
      ];
    }
  ];
}

{
  server = {
    interface = [
      "0.0.0.0"
    ];
    access-control = [ "10.69.0.0/16 allow" ];
  };

  forward-zone = [
    {
      name = ".";
      forward-addr = [
        "9.9.9.9"
	"149.112.112.112"
      ];
    }
  ];
}

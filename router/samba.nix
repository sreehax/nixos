{
  enable = true;
  securityType = "user";
  extraConfig = ''
    workgroup = WORKGROUP
    server string = router
    netbios name = router
    security = user
    guest account = guest
    map to guest = bad user
    fruit:copyfile = yes
    veto files = /._*/.DS_Store/
    delete veto files = yes
  '';
  shares = {
    public = {
      path = "/mnt/data/public";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0644";
      "directory mask" = "0755";
      writable = "yes";
    };
    private = {
      path = "/mnt/data/private";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "valid users" = "user";
      writable = "yes";
    };
    time_machine = {
      path = "/mnt/data/time_machine";
      "valid users" = "user";
      public = "no";
      writable = "yes";
      "fruit:aapl" = "yes";
      "fruit:time machine" = "yes";
      "vfs objects" = "catia fruit streams_xattr";
    };
  };
}

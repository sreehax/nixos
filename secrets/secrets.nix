let
  mbp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwx/H7u/Ni7W0AM+U8crN3EpV/0IBRvjtkahUEwjp/9";
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYI8038ZK8GFZmX2j8gwe5OR70+gP2PZFz79TCFvZQH";
  t480s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1WTWlpbr3Nb9L0yHW6IfscQhWgC8p3uZd8w4bojcrL";
  users = [
    mbp
    desktop
    t480s
  ];

  lux = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXkwJx5lPpRyvTrjJQ8qT+PRRZ6fYjgcatSpgGYMANI";
  systems = [ lux ];
in
{
  "nftables.age".publicKeys = users ++ systems;
  "vaultwarden.age".publicKeys = users ++ systems;
}

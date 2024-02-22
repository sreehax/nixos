''
flush ruleset

define wan_iface = "enp4s0f0"
define lan_iface = "br0"
define wg_iface = "wg0"

table inet filter {
  chain inbound_wan {
    udp dport 12345 accept
    tcp dport 22 accept
  }

  chain inbound_lan {
    icmp type echo-request limit rate 5/second accept

    tcp dport { 53, 22, 139, 445, 5357 } accept
    udp dport { 53, 67, 137, 138, 3702, 12345 } accept
  }

  chain input {
    type filter hook input priority 0
    policy drop

    ct state vmap { invalid : drop, established : accept, related : accept }

    iifname vmap { lo : accept, $wan_iface : jump inbound_wan, $lan_iface : jump inbound_lan, $wg_iface : jump inbound_lan }
  }

  chain forward {
    type filter hook forward priority 0
    policy drop
    
    ct state vmap { established : accept, related : accept, invalid : drop }

    meta iifname . meta oifname { $lan_iface . $wan_iface, $wan_iface . $lan_iface, $lan_iface . $wg_iface, $wg_iface . $lan_iface } accept
  }
}

table ip nat {
  chain prerouting {
    type nat hook prerouting priority 0
    policy accept
  }

  chain postrouting {
    type nat hook postrouting priority 100
    policy accept

    iifname $lan_iface oifname $wan_iface masquerade
  }
}
''

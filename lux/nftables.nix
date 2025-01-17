''
  flush ruleset

  define wan_iface = "ens3"
  define wg_iface = "wg0"

  table inet filter {
    chain inbound_wan {
      icmp type echo-request limit rate 5/second accept
      tcp dport { 22, 25, 53, 80, 143, 443, 465, 587, 993 } accept
      udp dport { 53, 12345 } accept
      icmpv6 type { nd-neighbor-solicit, nd-router-advert, nd-neighbor-advert } accept
      icmpv6 type echo-request limit rate 5/second accept
    }

    chain inbound_lan {
      icmp type echo-request limit rate 5/second accept
      tcp dport { 22, 25, 53, 80, 143, 443, 465, 587, 993 } accept
      udp dport { 53, 12345 } accept
    }

    chain input {
      type filter hook input priority 0
      policy drop

      ct state vmap { invalid : drop, established : accept, related : accept }

      iifname vmap { lo : accept, $wan_iface: jump inbound_wan, $wg_iface : jump inbound_lan }
    }

    chain forward {
      type filter hook forward priority 0
      policy drop

      ct state vmap { established : accept, related : accept, invalid : drop }

      meta iifname . meta oifname { $wg_iface . $wan_iface, $wan_iface . $wg_iface } accept
    }
  }

  table ip nat {
    chain prerouting {
      type nat hook prerouting priority -100
      policy accept
    }

    chain postrouting {
      type nat hook postrouting priority 100
      policy accept

      iifname $wg_iface oifname $wan_iface masquerade
    }
  }
''

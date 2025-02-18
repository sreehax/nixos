{
  mailserver = {
    enable = true;
    fqdn = "mail.ssree.dev";
    domains = [
      "ssree.dev"
      "hisonly.fans"
      "diabolicalbigblack.wang"
      "frostium.org"
    ];
    loginAccounts = {
      "connect@frostium.org" = {
        hashedPasswordFile = "/mnt/data/mail/users/connect@frostium.org";
      };
      "sreehari@frostium.org" = {
        hashedPasswordFile = "/mnt/data/mail/users/sreehari@frostium.org";
      };
      "felix@frostium.org" = {
        hashedPasswordFile = "/mnt/data/mail/users/felix@frostium.org";
      };
      "me@ssree.dev" = {
        hashedPasswordFile = "/mnt/data/mail/users/me@ssree.dev";
        aliases = [
          "sreehari@ssree.dev"
          "sydney@ssree.dev"
          "admin@ssree.dev"
          "postmaster@ssree.dev"
        ];
      };
      "felix@hisonly.fans" = {
        hashedPasswordFile = "/mnt/data/mail/users/felix@hisonly.fans";
      };
      "sreehari@hisonly.fans" = {
        hashedPasswordFile = "/mnt/data/mail/users/sreehari@hisonly.fans";
        aliases = [
          "sree@hisonly.fans"
        ];
      };
      "omar@hisonly.fans" = {
        hashedPasswordFile = "/mnt/data/mail/users/omar@hisonly.fans";
      };
      "sydney@diabolicalbigblack.wang" = {
        hashedPasswordFile = "/mnt/data/mail/users/sydney@diabolicalbigblack.wang";
        aliases = [
          "admin@diabolicalbigblack.wang"
          "sreehari@diabolicalbigblack.wang"
          "wisdom@diabolicalbigblack.wang"
        ];
      };
      "dogshit@diabolicalbigblack.wang" = {
        hashedPasswordFile = "/mnt/data/mail/users/dogshit@diabolicalbigblack.wang";
        catchAll = [ "diabolicalbigblack.wang" ];
      };
    };
    certificateScheme = "acme";
    # Get everything onto my directory
    indexDir = "/mnt/data/mail/dovecot/indices";
    mailDirectory = "/mnt/data/mail/vmail";
    openFirewall = false; # we use nftables bitch
    fullTextSearch = {
      enable = true;
      autoIndex = true;
      indexAttachments = true;
      enforced = "body";
    };
    dkimKeyBits = 2048;
    dkimSelector = "t2";
    backup.snapshotRoot = "/mnt/data/mail/rsnapshot";
    borgbackup.repoLocation = "/mnt/data/mail/borgbackup";
  };
  services.roundcube = {
    enable = true;
    hostName = config.mailserver.fqdn;
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };
}

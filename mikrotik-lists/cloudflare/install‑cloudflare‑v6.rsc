# Cloudflare IPv6 installer
/system script add name="cloudflare-v6" source={
  :log info "Download Cloudflare IPv6 List";
  /tool fetch url="https://raw.githubusercontent.com/heseifert/charts/refs/heads/main/mikrotik-lists/cloudflare/cloudflare-ips-v6.rsc" mode=https dst-path=cloudflare-ips-v6.rsc;
  :log info "Remove current Cloudflare IPv6 List";
  /ipv6 firewall address-list remove [find where list="cloudflare-ips-v6"];
  :log info "Import newest Cloudflare IPv6 List";
  /import file-name=cloudflare-ips-v6.rsc;
  /file remove cloudflare-ips-v6.rsc;
  :log info "Import Cloudflare IPv6 finish";
}

/system scheduler
add name="cf-v6-dl" start-time=startup+10m interval=1d on-event=cloudflare-v6

# Cloudflare IPv4 installer
/system script add name="cloudflare-v4" source={
  :log info "Download Cloudflare IPv4 List";
  /tool fetch url="https://raw.githubusercontent.com/heseifert/charts/refs/heads/main/mikrotik-lists/cloudflare/cloudflare-ips-v4.rsc" mode=https dst-path=cloudflare-ips-v4.rsc;
  :log info "Remove current Cloudflare IPv4 List";
  /ip firewall address-list remove [find where list="cloudflare-ips-v4"];
  :log info "Import newest Cloudflare IPv4 List";
  /import file-name=cloudflare-ips-v4.rsc;
  /file remove cloudflare-ips-v4.rsc;
  :log info "Import Cloudflare IPv4 finish";
}

/system scheduler
add name="cf-v4-dl" start-time=startup interval=1d on-event=cloudflare-v4

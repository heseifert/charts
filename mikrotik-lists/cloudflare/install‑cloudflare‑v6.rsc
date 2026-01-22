# Cloudflare IPv6 installer
/system script add name="cloudflare-v6-download" source={
  :log info "Downloading Cloudflare IPv6 List";
  /tool fetch url="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/main/mikrotik-lists/cloudflare/cloudflare-ips-v6.rsc" mode=https dst-path=cloudflare-ips-v6.rsc
}

/system script add name="cloudflare-v6-replace" source={
  :log info "Replacing Cloudflare IPv6 List";
  /ipv6 firewall address-list remove [find where list="cloudflare-ips-v6"]
  /import file-name=cloudflare-ips-v6.rsc
}

/system scheduler
add name="cf-v6-dl" start-time=startup+10m interval=1d on-event=cloudflare-v6-download
add name="cf-v6-rp" start-time=startup+15m interval=1d on-event=cloudflare-v6-replace

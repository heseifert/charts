# Cloudflare IPv4 installer
/system script add name="cloudflare-v4-download" source={
  :log info "Downloading Cloudflare IPv4 List";
  /tool fetch url="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/main/mikrotik-lists/cloudflare/cloudflare-ips-v4.rsc" mode=https dst-path=cloudflare-ips-v4.rsc
}

/system script add name="cloudflare-v4-replace" source={
  :log info "Replacing Cloudflare IPv4 List";
  /ip firewall address-list remove [find where list="cloudflare-ips-v4"]
  /import file-name=cloudflare-ips-v4.rsc
}

/system scheduler
add name="cf-v4-dl" start-time=startup interval=1d on-event=cloudflare-v4-download
add name="cf-v4-rp" start-time=startup+5m interval=1d on-event=cloudflare-v4-replace

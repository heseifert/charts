# Google IPv4 installer
/system script add name="google-v4-download" source={
  :log info "Downloading Google IPv4 List";
  /tool fetch url="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/main/mikrotik-lists/google/google-ips-v4.rsc" mode=https dst-path=google-ips-v4.rsc
}

/system script add name="google-v4-replace" source={
  :log info "Replacing Google IPv4 List";
  /ip firewall address-list remove [find where list="google-ips-v4"]
  /import file-name=google-ips-v4.rsc
}

/system scheduler
add name="google-v4-dl" start-time=startup+20m interval=1d on-event=google-v4-download
add name="google-v4-rp" start-time=startup+25m interval=1d on-event=google-v4-replace

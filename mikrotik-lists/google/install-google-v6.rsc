# Google IPv6 installer
/system script add name="google-v6-download" source={
  :log info "Downloading Google IPv6 List";
  /tool fetch url="https://raw.githubusercontent.com/heseifert/main/mikrotik-lists/google/google-ips-v6.rsc" mode=https dst-path=google-ips-v6.rsc
}

/system script add name="google-v6-replace" source={
  :log info "Replacing Google IPv6 List";
  /ipv6 firewall address-list remove [find where list="google-ips-v6"]
  /import file-name=google-ips-v6.rsc
}

/system scheduler
add name="google-v6-dl" start-time=startup+30m interval=1d on-event=google-v6-download
add name="google-v6-rp" start-time=startup+35m interval=1d on-event=google-v6-replace

# Google IPv6 installer
/system script add name="google-v6" source={
 :log info "Download Google IPv6 List";
  /tool fetch url="https://raw.githubusercontent.com/heseifert/charts/refs/heads/main/mikrotik-lists/google/google-ips-v6.rsc" mode=https dst-path=google-ips-v6.rsc;
  :log info "Remove current Google IPv6 List";
  /ipv6 firewall address-list remove [find where list="google-ips-v6"];
  :log info "Import newest Google IPv6 List";
  /import file-name=google-ips-v6.rsc;
  /file remove google-ips-v6.rsc;
  :log info "Import Google IPv6 finish";
}

/system scheduler
add name="google-v6-dl" start-time=startup+30m interval=1d on-event=google-v6

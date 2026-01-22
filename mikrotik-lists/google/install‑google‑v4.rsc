# Google IPv4 installer
/system script add name="google-v4" source={
  :log info "Download Google IPv4 List";
  /tool fetch url="https://raw.githubusercontent.com/heseifert/charts/refs/heads/main/mikrotik-lists/google/google-ips-v4.rsc" mode=https dst-path=google-ips-v4.rsc;
  :log info "Remove current Google IPv4 List";
  /ip firewall address-list remove [find where list="google-ips-v4"];
  :log info "Import newest Google IPv4 List";
  /import file-name=google-ips-v4.rsc;
  /file remove google-ips-v4.rsc;
  :log info "Import Google IPv4 finish";
}

/system scheduler
add name="google-v4-dl" start-time=startup+20m interval=1d on-event=google-v4

import requests
from datetime import datetime, timezone
import os
import argparse

GOOGLE_JSON_URL = "https://www.gstatic.com/ipranges/goog.json"

def generate_rsc(ip_list, output_file, list_name, ipv6=False):
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
    with open(output_file, "w") as f:
        f.write(f"# Generated on {now}\n")
        f.write("/ipv6 firewall address-list\n" if ipv6 else "/ip firewall address-list\n")
        for ip in ip_list:
            f.write(f"add list={list_name} address={ip}\n")
    print(f"{len(ip_list)} IPs geschrieben in {output_file}")

def fetch_google_ip_ranges():
    resp = requests.get(GOOGLE_JSON_URL)
    resp.raise_for_status()
    data = resp.json()
    return data.get("prefixes", [])

def main():
    parser = argparse.ArgumentParser(description="Generate Google IP lists")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--ipv4", action="store_true", help="Generate IPv4 list")
    group.add_argument("--ipv6", action="store_true", help="Generate IPv6 list")
    args = parser.parse_args()

    os.makedirs("mikrotik-lists/google", exist_ok=True)
    prefixes = fetch_google_ip_ranges()

    if args.ipv4:
        ipv4_list = sorted([p["ipv4Prefix"] for p in prefixes if "ipv4Prefix" in p])
        generate_rsc(ipv4_list,
                     "mikrotik-lists/google/google-ips-v4.rsc",
                     "google-ips-v4",
                     ipv6=False)
    elif args.ipv6:
        ipv6_list = sorted([p["ipv6Prefix"] for p in prefixes if "ipv6Prefix" in p])
        generate_rsc(ipv6_list,
                     "mikrotik-lists/google/google-ips-v6.rsc",
                     "google-ips-v6",
                     ipv6=True)

if __name__ == "__main__":
    main()

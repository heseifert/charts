import requests
from datetime import datetime, timezone
import os
import argparse

# URLs der Cloudflare Listen
CF_URL_V4 = "https://www.cloudflare.com/ips-v4"
CF_URL_V6 = "https://www.cloudflare.com/ips-v6"

def generate_rsc(url: str, output_file: str, list_name: str, ipv6=False):
    headers = {"User-Agent": "Mozilla/5.0 (GitHub Actions)"}
    resp = requests.get(url, headers=headers)
    resp.raise_for_status()
    data = resp.text.strip().splitlines()

    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
    with open(output_file, "w") as f:
        f.write(f"# Generated on {now}\n")
        f.write("/ipv6 firewall address-list\n" if ipv6 else "/ip firewall address-list\n")
        for ip in data:
            f.write(f"add list={list_name} address={ip}\n")
    print(f"{len(data)} IPs geschrieben in {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Generate Cloudflare IP lists")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--ipv4", action="store_true", help="Generate IPv4 list")
    group.add_argument("--ipv6", action="store_true", help="Generate IPv6 list")
    args = parser.parse_args()

    os.makedirs("mikrotik-lists/cloudflare", exist_ok=True)

    if args.ipv4:
        generate_rsc(CF_URL_V4,
                     "mikrotik-lists/cloudflare/cloudflare-ips-v4.rsc",
                     "cloudflare-ips-v4",
                     ipv6=False)
    elif args.ipv6:
        generate_rsc(CF_URL_V6,
                     "mikrotik-lists/cloudflare/cloudflare-ips-v6.rsc",
                     "cloudflare-ips-v6",
                     ipv6=True)

if __name__ == "__main__":
    main()

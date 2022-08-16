import os
from pprint import pprint

import click
import requests


@click.command()
@click.argument("common_name")
@click.option("--ttl", default="8760h", help="certificate validity")
@click.option(
    "--vault_token",
    default=os.environ.get("VAULT_TOKEN", ""),
    help="token to login to the vault",
)
@click.option(
    "--vault_addr", default=os.environ.get("VAULT_ADDR", ""), help="address of the vault"
)
@click.option("--output_key", default="key.pem", help="output file for the key")
@click.option(
    "--output_cert", default="cert.pem", help="output file for the certificate"
)
def main(common_name, ttl, vault_token, vault_addr, output_key, output_cert):
    url = f"{vault_addr}/v1/pki_int/issue/home-dot-arpa"
    headers = {"X-Vault-Token": vault_token}
    data = {
        "common_name": common_name,
        "ttl": ttl,
    }

    response = requests.post(url, headers=headers, json=data)
    if response.ok:
        r = response.json()
        pprint(r)
        certificate = r["data"]["certificate"]
        private_key = r["data"]["private_key"]
        ca_chain = r["data"]["ca_chain"]
        with open(output_cert, "w") as out:
            out.write(certificate)
            out.write("\n")
            for item in ca_chain:
                out.write(item)
                out.write("\n")
        with open(output_key, "w") as out:
            out.write(private_key)
    else:
        print(response.body())


if __name__ == "__main__":
    main()

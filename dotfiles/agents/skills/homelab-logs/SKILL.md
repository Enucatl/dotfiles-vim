---
name: homelab-logs
description: Query centralized Loki logs for homelab infrastructure such as Proxmox hosts, VMs, Docker containers, Puppet, networking, and self-hosted services. Use this when logs are needed for diagnosis or event reconstruction; prefer Loki over local journalctl and do not ask the user to run sudo journalctl.
---

# Homelab Logs

Use the centralized Loki instance before attempting to read local logs:

`https://loki.docker.home.arpa/loki/api/v1/query_range`

Query it directly with LogQL over HTTP, normally using `curl --fail --silent --show-error --get` and `--data-urlencode` for query parameters. Bound every query to a relevant time range and set a reasonable `limit`; use `direction=backward` when recent events are most useful.

## Known labels

The log shippers use these labels:

- Systemd journal: `{job="systemd-journal", host="<host>"}`. The systemd unit is available as `service_name`.
- Docker: `{job="docker", host="<host>", service_name="<compose-project>/<service>"}`. When Compose labels are unavailable, `service_name` may be the Docker container name.
- File-based logs: `{job="varlogs", host="<host>"}`.

Use the host's actual Puppet certname, such as `proxmox.home.arpa`, `proxmox-cortex.home.arpa`, or `docker.home.arpa`. If the relevant labels are uncertain, query Loki's label or stream endpoints first instead of guessing.

## Query workflow

1. Identify the likely host, source job, service/container, time window, and distinctive error text.
2. Start with the narrowest useful label selector, then add LogQL line filters such as `|= "timeout"` or `|~ "(?i)error|failed"`.
3. Query `query_range` and inspect the JSON response under `data.result`; preserve timestamps and labels when summarizing findings.
4. Widen the time range or remove one filter only when the first query is empty or inconclusive.
5. State the Loki URL, LogQL selector, and time window used when reporting conclusions.

Do not request `sudo journalctl` for homelab logs. If Loki is unreachable, returns an error, or has no matching data, report that clearly and troubleshoot the Loki query or access path. Use local `journalctl` only when the user explicitly authorizes a local fallback or the task is specifically about the log-shipping agent before ingestion.

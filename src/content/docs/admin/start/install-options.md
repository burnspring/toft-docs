---
title: Ways to install
description: One box with Docker Compose, or a cluster with the Helm chart — the same image, built from source, behind both.
---

Two supported shapes. Both run the same Toft image, which you build from the
source — no image is published. Build it for linux/amd64 or linux/arm64 and
always tag it with a version; never use `latest`:

```bash
git clone https://github.com/burnspring/toft.git && cd toft
docker build -t <registry>/toft:<version> .
```

| | One box (Docker Compose) | Cluster (Helm chart) |
|---|---|---|
| **Apps run** | In **shared mode**: processes run by Toft's agent, each as its own OS account | In **isolated mode**: one container per app, with its own network policy |
| **Choose it for** | A team, a department, a first install | App-to-app isolation, mixed resource profiles, an existing Kubernetes |
| **Jobs run** | As processes on the machine, under their app's account | In their own pods |
| **Not available** | Isolated execution, the artifact store, telemetry export | — |

## One box

You need Linux (x86_64 or arm64) with Docker and Compose, 4 GB of RAM and 20 GB
free. From a clone of the source:

```bash
cd deploy/compose
cp .env.example .env    # fill in the secrets it lists; each says how to make one
docker compose -f compose.yml -f compose.build.yml up -d --build
```

That builds the image from the checkout and starts it beside Postgres. The
first build takes a while. Sign in as `admin`: the first password is printed
once, in a `FIRST BOOT` banner in `docker compose logs toft`, and the first
sign-in replaces it. Back up `.env` — its `ENCRYPTION_KEY` is the only thing
that can decrypt your app secrets.

The install listens on **loopback only** (`:8080` and `:8081`). Reach it over an
SSH tunnel forwarding both ports, or put a TLS proxy in front and set `BASE_URL`,
`APPS_BASE_URL` and `TRUSTED_PROXY_CIDRS`. Back up `.env` — its `ENCRYPTION_KEY`
is the only thing that can decrypt the install's app secrets — and the two Docker
volumes, `postgres-data` and `toft-data`. [Upgrading](../upgrading/) covers upgrades.

On a cloud VM, keep deployed apps away from the metadata endpoint, where the
machine's credentials are: add `-f compose.metadata.yml` to the command above
(or list all three files in `COMPOSE_FILE` in `.env`).

## A cluster

The Helm chart is `deploy/charts/toft` in the source. Push the image you built
to a registry the cluster can pull from and set `image.repository` to it; there
is no default, and the render fails until you do. `image.tag` defaults to the
chart's app version. `values-aks.yaml` beside the chart is a worked example for
Azure. Isolated mode also needs:

- an [artifact store](../../apps/artifact-store/) — a workload cannot read the
  platform's local `APPS_DIR`;
- at least one [runner image](../../build/runner-images/);
- a callback address the workloads can resolve.

Amazon ECS is a second isolated backend. Set **one** of `KUBE_NAMESPACE` or
`ECS_CLUSTER`; both is refused at startup. Execution mode is always `shared` or
`isolated`, never a backend name, and an install can offer both — see
[Execution modes](../../apps/execution-modes/).

:::caution[Adapting the chart]
Five things are compiled into the binary and must never be templated: the
`app.kubernetes.io/name: toft` pod label, workload UID `10001`, the
unauthenticated `/api/v1/config` probe, the `toft-workload` ServiceAccount, and
the `toft-bootstrap` token audience. Change one and the install starts but cannot
start a workload.
:::

## What you provide

| | |
|---|---|
| **Postgres 17** | The binary migrates the schema at startup. The one-box Compose file runs its own. |
| **TLS** | Terminated by your proxy or ingress. |
| **An apps address** | A second origin. A second port works; a second hostname is easier to put TLS in front of. |

---
title: Locking and retirement
description: The administrator's stop — what a lock blocks, who can set one, and using it to retire an app.
---

A lock stops an app and keeps it stopped. Unlike `stopped`, which the owner
controls, **the owner cannot lift a lock**.

| | Set by | Lifted by |
|---|---|---|
| `stopped` | The owner | The owner |
| Lock | An administrator, or the dependency sweep | An administrator |

**Locking stops the workload; unlocking does not start it.** Someone still has to
press start.

API: `POST /api/v1/apps/{id}/lock` and `DELETE /api/v1/apps/{id}/lock`.

## What it blocks

Deploying, starting, changing visibility, **rolling back**, running jobs,
**sharing** (adding a grant or approving an access request), **transferring
ownership**, attaching storage, choosing an integration's destination or sending
a test message, resetting the app's data, and the rest of the enforcement list.
Narrowing stays open under a lock: removing a grant, denying a request,
detaching storage, deleting old deployments or the app itself, and your own
**Transfer apps** for a leaver. A refusal is `409` and carries your message. There
is no flag, API call or redeploy that bypasses it.

Jobs are held in every form: a start is refused, a run queued before the lock is
cancelled at dispatch, and a run in flight is cancelled by the jobs sweep.

## Say why

A lock carries your message, shown on every refusal — the app page, the CLI, and
a visitor at the app's URL. **Admin → Messages → Locked app message**
(`app_locked_message`) is the default for visitors. Say what to do next.

## Who locked it

| Source | Meaning |
|---|---|
| `admin` | An administrator |
| `dependency` | The [dependency sweep](../../security/dependencies/), on a finding at or above **Lock a serving app when it installs** (`dependency_lock_on`) |

The sweep never overwrites a person's lock. An app the sweep locked and you
unlock is **locked again on the next pass** if the finding still matches — use a
waiver instead. The owner can also lift a `dependency` lock themselves by
deploying a release without the package; nothing but you lifts an `admin` lock.

## Retirement is a lock

There is no separate retired state. Your message is what tells the two apart:

> Retired 2026-08. The month-end pack moved to `finance-close`. Ask
> #finance-platform if you need the old numbers.

[System checks](../../operate/checks/) counts locked and withheld apps
without raising the verdict: a lock is a decision, not a fault.

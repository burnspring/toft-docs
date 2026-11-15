---
title: Licensing
description: Toft is free under the Apache License 2.0. Every install has every feature, needs no key and contacts no vendor.
---

Toft is free and open source, under the Apache License 2.0. Every install has
every feature switched on for you to use, with no key to enter, no tier, no term
and no limit on apps or users.

- **Nothing to enter.** There is no license page. An old bookmark to
  **Admin → License** opens **Admin → Features**, which shows what this build
  offers and what you have switched on.
- **Nothing is locked.** A capability you have not configured is hidden;
  nothing is ever shown as unavailable because of a license.
- **No outbound traffic.** An install never contacts the vendor: no check-in,
  no usage counts, no reachability probe. There is no vendor address compiled
  in, and nothing an operator or a browser sets can point it at one.

The API routes that used to set and check a key, `/api/v1/admin/license` and
`/api/v1/admin/license/check`, no longer exist.

# 📂 MessagePorts

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

`listen(dispatch:info:_:)` creates a named local Core Foundation message port and schedules its callback on the supplied queue. Its Boolean return value indicates whether the port is valid.

`send` opens a remote port and sends a message ID and a Data payload. The result reports delivery status. An empty payload produces a transport error once the remote port has been opened. Send and receive timeouts both default to zero.

## Contents

- [SKMessagePort+Define.swift](SKMessagePort%2BDefine.swift)
- [SKMessagePort.swift](SKMessagePort.swift)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

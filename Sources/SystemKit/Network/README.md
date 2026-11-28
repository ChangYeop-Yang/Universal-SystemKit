# 📂 Network

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

Use `SKNetworkInterface.allInterfaces` for a snapshot of local interfaces and addresses on iOS or macOS. Use `SKNetworkMonitor` to follow changes over time. Pass a handler at initialization and call `startMonitor()` to begin.

The monitor delivers path updates on its background queue. Dispatch UI work to the main thread in your handler. Call `stopMonitor()` to cancel the underlying NWPathMonitor.

## Contents

- [SKNetworkInterface.swift](SKNetworkInterface.swift)
- [SKNetworkInterfaceDefine.swift](SKNetworkInterfaceDefine.swift)
- [SKNetworkMonitor.swift](SKNetworkMonitor.swift)
- [SKNetworkMonitorDefine.swift](SKNetworkMonitorDefine.swift)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

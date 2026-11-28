# 📂 FileSystem

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

`SKDispatchFile` accepts a path and a completion handler for a read or write. Use `SKDispatchFileMonitor` to receive change events between `start()` and `stop()`. Its companion file defines the event handler type.

`SKFileLock` can work with a file descriptor. Its `lock()` requests an exclusive, nonblocking lock and returns whether it succeeded. Check that result before doing work that requires exclusive access, then call `unlock()`.

## Contents

- [SKDispatchFile.swift](SKDispatchFile.swift)
- [SKDispatchFileMonitor+Define.swift](SKDispatchFileMonitor%2BDefine.swift)
- [SKDispatchFileMonitor.swift](SKDispatchFileMonitor.swift)
- [SKFileLock.swift](SKFileLock.swift)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

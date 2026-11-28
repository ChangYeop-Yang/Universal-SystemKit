# 📂 Concurrency

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

`SKAtomicValue` serializes reads and writes on a private queue. Use its `mutate` method for a read-modify-write operation such as incrementing a counter. Separate reads and writes each acquire the queue independently.

`SKAsyncOperation` exposes execution state to Foundation's operation queue. `SKDispatchTimer` schedules callbacks and keeps its timer state in the companion definition file.

## Contents

- [SKAsyncOperation.swift](SKAsyncOperation.swift)
- [SKAtomicValue.swift](SKAtomicValue.swift)
- [SKDispatchTimer+Define.swift](SKDispatchTimer%2BDefine.swift)
- [SKDispatchTimer.swift](SKDispatchTimer.swift)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

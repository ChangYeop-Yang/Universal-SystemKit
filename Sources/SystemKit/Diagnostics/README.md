# 📂 Diagnostics

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

On iOS and macOS, `SKCrashReporter.enable(handleSignal:)` installs a PLCrashReporter callback and checks for a pending crash report from an earlier run. If it finds one, it invokes the save path. `getCrashReport` reads report data and produces a text representation. Disabling the reporter purges its pending report and releases the wrapper's reference.

## Contents

- [SKCrashReporter.swift](SKCrashReporter.swift)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

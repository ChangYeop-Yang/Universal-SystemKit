# 📂 scripts

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

`log-ci-step.sh` runs a command, saves its output and returns its exit status to the workflow. Use `smoke-test-swift-package.sh` to build a separate release executable that imports both package products. It needs a writable `RUNNER_TEMP` directory for the temporary consumer package. The Python report script reads the installed SDKs and the deployment targets from the manifest.

## Contents

- [api-reference-report.py](api-reference-report.py)
- [log-ci-step.sh](log-ci-step.sh)
- [smoke-test-swift-package.sh](smoke-test-swift-package.sh)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

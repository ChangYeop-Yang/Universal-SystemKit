# 📂 SecurityMigrationTests

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

The known-answer test encrypts an empty payload with a zero AES-128 key and IV, then checks the ciphertext against a fixed value. The boundary test checks which UTF-8 strings fit the legacy buffers, including the NUL terminator.

The compatibility test exercises 128-, 192- and 256-bit keys and payload sizes around the AES block boundary. It compares ciphertext bytes and decrypts each implementation's output with the other implementation. Its key and IV strings fit the legacy buffers.

## Contents

- [SecurityMigrationTests.swift](SecurityMigrationTests.swift)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

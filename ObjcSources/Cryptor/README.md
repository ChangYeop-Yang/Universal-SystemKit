# 📂 Cryptor

[![Browse folder contents](https://img.shields.io/badge/Browse-Contents-blue)](#contents)

## Overview

`SKSecurity.h` declares the singleton, the AES key sizes and the methods that accept a string key, a string IV and binary data. The Objective-C++ implementation calls CommonCrypto with CBC mode and PKCS#7 padding.

When reading legacy ciphertext, the string conversion matters. The code writes UTF-8 into fixed-length buffers of 16, 24 or 32 bytes for the key and 16 bytes for the IV. Those buffers also need room for the trailing NUL. The implementation ignores conversion failure, so an input that fills or exceeds its buffer has no reliable conversion contract.

## Contents

- [SKSecurity.h](SKSecurity.h)
- [SKSecurity.mm](SKSecurity.mm)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

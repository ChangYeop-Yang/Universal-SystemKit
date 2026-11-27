# Package layout

[![SwiftPM source layout](https://img.shields.io/badge/SwiftPM-Source_layout-orange)](#source-layout)

## Source layout

SwiftPM builds one Swift module from `Sources/SystemKit`. Feature folders help readers find related operations. For example, file monitoring and locking belong in `FileSystem`, and process enumeration and signal observation belong in `Processes`. Keep a feature's public result types and callbacks beside its implementation. Folder READMEs describe local responsibilities. The manifest excludes these documents from the target and processes the privacy manifest at its root.

## Encryption compatibility

Applications can depend on both SystemKit and SystemKit_Objc. The Objective-C product owns the runtime name SKSecurity. The migration test links this product and calls an isolated Swift implementation of AES-CBC with PKCS#7 padding. The test checks ciphertext bytes in both directions.

The existing NSString conversion needs space for a trailing NUL. For AES-256 the key buffer has 32 bytes. Its documented 64-character hexadecimal example cannot fit, and the implementation ignores the conversion result. The same issue applies to a generated 16-character IV in a 16-byte buffer. A successful round trip on one SDK cannot define the key and IV bytes for all previous releases. Keep the existing product available for stored ciphertext until the supported migration inputs and Objective-C consumer interface are verified.

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

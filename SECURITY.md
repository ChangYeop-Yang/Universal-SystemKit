# 🛡️ Universal SystemKit security policy

[![Private security contact by email](https://img.shields.io/badge/Security_contact-Email-blue)](mailto:yeop9657@naver.com)

**Report a suspected vulnerability privately to [yeop9657@naver.com](mailto:yeop9657@naver.com). A maintainer will reply within 7 calendar days of receiving your report.** A short description of what you observed is enough to start. You can send more information in the same thread later.

## 📬 Choose a private channel

- **Email.** Use a subject such as `[Universal SystemKit security] File access on macOS`. Start with a brief description and redacted evidence. If further evidence contains sensitive material, describe what you have and agree on a suitable transfer method with the maintainer before sharing it.
- **GitHub.** If the repository's Security tab shows **Report a vulnerability**, you may use the private form. If the button is missing, the form fails, or you prefer to report without a GitHub account, use the email address above. [Repository Security tab](https://github.com/ChangYeop-Yang/Universal-SystemKit/security)
- **Follow-up.** Use one private thread so the maintainer can match updates to the original report. If 7 calendar days pass without a response, email the original submission date, subject, and any private report reference. If an email bounces, check the address and try the private GitHub form if available.

Keep sensitive details out of public issues, pull requests, discussions, CI logs, and shared links. If information is already public, send the maintainer its location privately so they can assess the exposure. For ordinary bugs or usage questions, follow the [contributing guide](CONTRIBUTING.md).

## 📦 Scope and affected versions

Report security issues in either SwiftPM product (`SystemKit` or `SystemKit_Objc`), the package manifest, bundled resources, or this repository's build and release workflows. Useful reports describe who could be affected and under what conditions. Examples include unexpected access to private files, sensitive data in output, and package artifacts that differ from the intended build.

| Where you found the issue | What to report |
| --- | --- |
| A tagged release | Give the exact package version your app resolved. You can find it in the SystemKit entry in your app's `Package.resolved`. |
| A checkout of `main` or a pinned revision | Give the commit SHA and mention any local changes that affect the result. |
| An older release | Send the version you used, even if you cannot check a newer one. The maintainer will assess which versions are affected and whether a fix can be applied to an older release. |
| A dependency | Report a dependency issue to its maintainers through their private channel. If SystemKit users may also be affected, send this project the dependency name, resolved version, relevant usage, and any public advisory. |

Reports are welcome for any version. Fix availability for each release depends on the findings. Use the advisory or release notes for the affected range and the first fixed version when those are known. [Release history](https://github.com/ChangYeop-Yang/Universal-SystemKit/releases)

## 📝 What to include

| Detail | Information that helps the maintainer |
| --- | --- |
| Summary and impact | What happened, what you expected, and which data, permissions, or package users could be affected. Distinguish what you observed from what you suspect. |
| Environment | Product, tag or commit, affected API or workflow, Apple platform and OS version. For build issues, include Xcode and Swift versions. For device-specific behavior, say whether you used hardware or a simulator. |
| Conditions | Relevant app permissions, entitlements, or build settings. Describe whether the issue occurs with default settings or requires a particular configuration. |
| Evidence | A short description from your own test environment and the smallest relevant, redacted log excerpt. For a workflow issue, include a run ID and step name if available. |
| Current exposure | Say whether an affected release is public, a credential may be exposed, or you have observed harm. If you know a temporary way to reduce the impact, mention its limits. |

Use sample data and systems you own or have permission to test. Omit passwords, tokens, signing keys, personal identifiers, and customer records. Crop screenshots and remove private paths from logs. If a real credential was exposed, notify its owner privately so they can revoke or rotate it. Identify the credential by its purpose in the report and keep its value private.

## 🔎 What happens after a report

1. **First response.** Within 7 calendar days of receipt, a maintainer will acknowledge the report and explain the next step or ask for missing details. Investigation and release dates depend on the issue.
2. **Assessment.** The maintainer reviews the reported behavior, affected products and versions, required access, and likely impact. If the report is a duplicate, belongs upstream, or cannot be confirmed, the maintainer will explain the outcome to the extent they can share and identify any information that would help.
3. **Fix and verification.** For a confirmed issue, the maintainer considers a fix or a temporary way to reduce exposure. They may ask you to verify a proposed change with sample data. Use the private thread for findings and status questions while the work is underway.
4. **Coordinated disclosure.** Discuss publication timing in the private thread so users can act when details become public. A published notice should identify affected products and versions, conditions for exposure, and an upgrade or mitigation. Tell the maintainer whether you would like public credit and which name to use. Public credit requires your consent.

## 📢 Find fixes and check your application

Check published advisories and release notes for the fixed tag or mitigation. Compare the affected range with the revision recorded in your app's `Package.resolved`. After updating the dependency, verify the resolved version and rebuild the affected app target. If a fixed version is still unavailable, follow the mitigation in the notice and check it for updates. [Security advisories](https://github.com/ChangYeop-Yang/Universal-SystemKit/security/advisories) · [Releases](https://github.com/ChangYeop-Yang/Universal-SystemKit/releases)

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.

# Security Policy

## 🔒 Security Features

MeDrop implements multiple security layers to protect your data:

### 1. **App Sandboxing**
- ✅ Runs in Apple's App Sandbox
- ✅ Uses Powerbox for file access (user-selected files only)
- ✅ No Full Disk Access required
- ✅ Minimal permissions (read-only on dragged files)

### 2. **Safe File Handling**
- ✅ Uses native Swift APIs (URL, NSSharingService)
- ✅ No shell commands or string interpolation
- ✅ Protection against malicious filenames (e.g., `rm -rf`)
- ✅ Files are only accessed when explicitly dragged by user

### 3. **TCC Compliance**
- ✅ Accessibility permission clearly explained in Info.plist
- ✅ `NSAccessibilityUsageDescription` provided
- ✅ Only used for keyboard modifier detection
- ✅ No screen recording or other invasive permissions

### 4. **Hardened Runtime**
- ✅ JIT disabled
- ✅ Unsigned executable memory blocked
- ✅ DYLD environment variables disabled
- ✅ Library validation enabled

### 5. **Automated Security**
- ✅ GitHub CodeQL scanning on every push
- ✅ Dependabot for vulnerability detection
- ✅ Weekly automated security audits

## 🛡️ Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## 📢 Reporting a Vulnerability

If you discover a security vulnerability in MeDrop, please report it responsibly:

### How to Report

1. **DO NOT** open a public GitHub issue
2. Email: [Create a security advisory](https://github.com/Amalbajith2003/MeDrop/security/advisories/new)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Response Time**: Within 48 hours
- **Fix Timeline**: Critical issues within 7 days
- **Credit**: Security researchers will be credited (if desired)

## 🔐 Verification

### SHA-256 Checksums

Verify your download hasn't been tampered with:

```bash
shasum -a 256 MeDrop.app/Contents/MacOS/MeDrop
```

Official checksums will be published with each release.

### Code Signing

Future releases will be signed with an Apple Developer ID certificate. For now:
- Build from source for maximum trust
- Verify the source code on GitHub
- Check CodeQL scan results

## 🔍 Security Best Practices

When using MeDrop:

1. **Download from Official Sources**
   - GitHub releases only
   - Verify checksums
   - Build from source if concerned

2. **Grant Minimal Permissions**
   - Only grant Accessibility when prompted
   - No other permissions needed

3. **Keep Updated**
   - Enable Dependabot notifications
   - Update when security patches are released

4. **Review Code**
   - Source code is fully open
   - Security audits welcome
   - Report issues responsibly

## 📋 Security Checklist

- [x] App Sandboxing enabled
- [x] Powerbox for file access
- [x] No shell commands
- [x] TCC compliance
- [x] Hardened Runtime
- [x] CodeQL scanning
- [x] Dependabot enabled
- [ ] Code signing (planned)
- [ ] Notarization (planned)

## 🤝 Security Acknowledgments

We thank the security community for responsible disclosure and helping keep MeDrop secure.

---

**Last Updated**: December 29, 2025

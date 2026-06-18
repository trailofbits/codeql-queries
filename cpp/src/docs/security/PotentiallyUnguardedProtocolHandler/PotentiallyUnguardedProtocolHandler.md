# Potentially unguarded protocol handler invocation

This query detects calls to URL protocol handlers with untrusted input that may not be properly validated for dangerous protocols. This vulnerability is related to CWE-939 (Improper Authorization in Handler for Custom URL Scheme) and aligns with CVE-2022-43550.

When applications invoke protocol handlers (like `rundll32 url.dll,FileProtocolHandler` on Windows, `xdg-open` on Linux, `open` on macOS, or Qt's `QDesktopServices::openUrl()`), untrusted URLs can potentially trigger dangerous protocols such as `file://`, `smb://`, or other custom handlers that may lead to unauthorized file access, command execution, or other security issues.

## Detected patterns

The query identifies several common protocol handler invocation patterns:

- **Windows**: `rundll32 url.dll,FileProtocolHandler` via system calls
- **Linux**: `xdg-open` via system calls
- **macOS**: `open` command via system calls
- **Qt applications**: `QDesktopServices::openUrl()`

## Recommendation

Always validate URL schemes before passing them to protocol handlers. Only allow safe protocols like `http://` and `https://`. Reject or sanitize URLs containing potentially dangerous protocols.

## Example

The following vulnerable code passes untrusted input directly to a protocol handler:

```cpp
#include <QDesktopServices>
#include <QUrl>

void openUserUrl(const QString& userInput) {
    // VULNERABLE: No validation of the URL scheme
    QDesktopServices::openUrl(QUrl(userInput));
}
```

An attacker could provide a URL like `file:///etc/passwd` or `smb://attacker-server/share` to access unauthorized resources.

The corrected version validates the URL scheme before opening:

```cpp
#include <QDesktopServices>
#include <QUrl>

void openUserUrl(const QString& userInput) {
    QUrl url(userInput);
    QString scheme = url.scheme().toLower();

    // Only allow safe protocols
    if (scheme == "http" || scheme == "https") {
        QDesktopServices::openUrl(url);
    } else {
        // Log error or show warning to user
        qWarning() << "Rejected unsafe URL scheme:" << scheme;
    }
}
```

For system command invocations:

```cpp
void openUserUrlViaShell(const char* userInput) {
    // VULNERABLE: Untrusted input passed to xdg-open
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "xdg-open '%s'", userInput);
    system(cmd);
}
```

Should be corrected to validate the scheme:

```cpp
bool isValidScheme(const char* url) {
    return (strncasecmp(url, "http://", 7) == 0 ||
            strncasecmp(url, "https://", 8) == 0);
}

void openUserUrlViaShell(const char* userInput) {
    if (isValidScheme(userInput)) {
        char cmd[512];
        snprintf(cmd, sizeof(cmd), "xdg-open '%s'", userInput);
        system(cmd);
    }
}
```

## References

- [CWE-939: Improper Authorization in Handler for Custom URL Scheme](https://cwe.mitre.org/data/definitions/939.html)
- [CVE-2022-43550: USB Creator has insufficiently protected credentials](https://ubuntu.com/security/CVE-2022-43550)

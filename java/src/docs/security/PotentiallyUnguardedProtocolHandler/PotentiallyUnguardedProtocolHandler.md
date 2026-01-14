# Potentially unguarded protocol handler invocation

This query detects calls to URL protocol handlers with untrusted input that may not be properly validated for dangerous protocols. This vulnerability is related to CWE-939 (Improper Authorization in Handler for Custom URL Scheme) and aligns with CVE-2022-43550.

When Java applications invoke protocol handlers (like `Desktop.browse()`, `Runtime.exec()` with `xdg-open`/`open`, or `rundll32 url.dll,FileProtocolHandler` on Windows), untrusted URLs can potentially trigger dangerous protocols such as `file://`, `smb://`, or other custom handlers that may lead to unauthorized file access, command execution, or other security issues.

## Detected patterns

The query identifies several common protocol handler invocation patterns:

- **Java AWT**: `Desktop.browse(URI)` - the platform-agnostic standard
- **Windows**: `Runtime.exec()` with `rundll32 url.dll,FileProtocolHandler`
- **Linux**: `Runtime.exec()` with `xdg-open`
- **macOS**: `Runtime.exec()` with `open` command

## Recommendation

Always validate URL schemes before passing them to protocol handlers. Only allow safe protocols like `http://` and `https://`. Reject or sanitize URLs containing potentially dangerous protocols.

## Example

The following vulnerable code passes untrusted input directly to a protocol handler:

```java
import java.awt.Desktop;
import java.net.URI;

public class UrlOpener {
    public void openUserUrl(String userInput) throws Exception {
        // VULNERABLE: No validation of the URL scheme
        Desktop.getDesktop().browse(new URI(userInput));
    }
}
```

An attacker could provide a URL like `file:///etc/passwd` or `smb://attacker-server/share` to access unauthorized resources.

The corrected version validates the URL scheme before opening:

```java
import java.awt.Desktop;
import java.net.URI;

public class UrlOpener {
    public void openUserUrl(String userInput) throws Exception {
        URI uri = new URI(userInput);
        String scheme = uri.getScheme();

        // Only allow safe protocols
        if ("http".equalsIgnoreCase(scheme) || "https".equalsIgnoreCase(scheme)) {
            Desktop.getDesktop().browse(uri);
        } else {
            throw new SecurityException("Rejected unsafe URL scheme: " + scheme);
        }
    }
}
```

For system command invocations:

```java
public class UrlOpener {
    public void openUserUrlViaShell(String userInput) throws Exception {
        // VULNERABLE: Untrusted input passed to xdg-open
        Runtime.getRuntime().exec(new String[]{"xdg-open", userInput});
    }
}
```

Should be corrected to validate the scheme:

```java
import java.net.URI;

public class UrlOpener {
    private boolean isValidScheme(String url) {
        try {
            URI uri = new URI(url);
            String scheme = uri.getScheme();
            return "http".equalsIgnoreCase(scheme) || "https".equalsIgnoreCase(scheme);
        } catch (Exception e) {
            return false;
        }
    }

    public void openUserUrlViaShell(String userInput) throws Exception {
        if (isValidScheme(userInput)) {
            Runtime.getRuntime().exec(new String[]{"xdg-open", userInput});
        } else {
            throw new SecurityException("Invalid or unsafe URL scheme");
        }
    }
}
```

## References

- [CWE-939: Improper Authorization in Handler for Custom URL Scheme](https://cwe.mitre.org/data/definitions/939.html)
- [CVE-2022-43550: USB Creator has insufficiently protected credentials](https://ubuntu.com/security/CVE-2022-43550)

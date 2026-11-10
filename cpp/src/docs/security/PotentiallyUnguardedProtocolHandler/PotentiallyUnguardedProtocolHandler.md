# Potentially unguarded protocol handler invocation
Desktop URL handlers accept every scheme registered with the operating system. Passing an untrusted URL to one of these handlers can invoke an unintended application or expose local resources.


## Recommendation
Parse the URL and allow only the schemes required by the application before invoking the protocol handler. For web links, allow only HTTP and HTTPS.


## Example

```cpp
#include <QDesktopServices>
#include <QUrl>

void openUrl(const char *input) {
  QDesktopServices::openUrl(QUrl(input)); // BAD
}

void openWebUrl(const char *input) {
  QUrl url(input);
  if (url.scheme() == "https") {
    QDesktopServices::openUrl(url); // GOOD
  }
}

```
The bad example opens an untrusted URL directly. The good example first checks that the URL uses HTTPS.


## References
* CWE-939: [Improper Authorization in Handler for Custom URL Scheme](https://cwe.mitre.org/data/definitions/939.html)
* CVE-2022-43550: [Jitsi Desktop Client RCE by interacting with malicious URL schemes](https://hackerone.com/reports/1692603)
* Common Weakness Enumeration: [CWE-939](https://cwe.mitre.org/data/definitions/939.html).

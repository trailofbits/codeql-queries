// Forward declarations - minimal to avoid system header dependencies
extern "C" {
int system(const char *);
int sprintf(char *, const char *, ...);
int strncmp(const char *, const char *, unsigned long);
}

// Mock QString class
struct QString {
  const char *data;
  QString(const char *s) : data(s) {}
  bool operator==(const char *other) const;
};

// Mock Qt-like class for QDesktopServices::openUrl
struct QUrl {
  const char *url;
  QUrl(const char *s) : url(s) {}
  QString scheme() const;
  bool startsWith(const char *prefix) const;
};

struct QDesktopServices {
  static bool openUrl(const QUrl &url);
};

// Untrusted input sources
extern "C" char *getUserInput();
extern "C" const char *getUrlParam();

// BAD: QDesktopServices::openUrl with untrusted input
void bad1_qt(const char *userUrl) {
  QUrl url(userUrl);
  QDesktopServices::openUrl(url); // BAD
}

void bad2_qt() {
  const char *input = getUrlParam();
  QUrl url(input);
  QDesktopServices::openUrl(url); // BAD
}

void safe1_qt() {
  QUrl url("https://example.com");
  QDesktopServices::openUrl(url); // GOOD - no taint
}

void safe2_qt(const char *userUrl) {
  if (strncmp(userUrl, "https://", 8) == 0 ||
      strncmp(userUrl, "http://", 7) == 0) {
    QUrl url(userUrl);
    QDesktopServices::openUrl(url); // GOOD
  }
}

void safe3_qt(QUrl &url) {
  if (url.scheme() == "https" || url.scheme() == "http") {
    QDesktopServices::openUrl(url); // GOOD
  }
}
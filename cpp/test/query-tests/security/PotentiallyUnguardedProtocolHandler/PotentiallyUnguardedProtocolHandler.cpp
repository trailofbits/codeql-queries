// Forward declarations - minimal stubs
extern "C" {
int read(int fd, void *buf, unsigned long count);
int system(const char *);
int sprintf(char *, const char *, ...);
int strncmp(const char *, const char *, unsigned long);
}

struct QString {
  const char *data;
  QString(const char *s) : data(s) {}
  bool operator==(const char *other) const;
  bool startsWith(const char *prefix) const;
};

struct QUrl {
  const char *url;
  QUrl(const char *s) : url(s) {}
  QString scheme() const;
};

struct QDesktopServices {
  static bool openUrl(const QUrl &url);
};

// BAD: read() into buffer, then pass to openUrl without scheme check
void bad1_qt_read() {
  char buf[1024];
  read(0, buf, sizeof(buf));
  QDesktopServices::openUrl(QUrl(buf)); // BAD
}

// BAD: read() into buffer, intermediate usage, then openUrl without guard
void bad2_qt_read_indirect() {
  char buf[1024];
  char url[2048];
  read(0, buf, sizeof(buf));
  sprintf(url, "file://%s", buf);
  // no scheme check before opening
  QDesktopServices::openUrl(QUrl(url)); // BAD
}

// GOOD: hardcoded URL
void safe1_qt_hardcoded() {
  QDesktopServices::openUrl(QUrl("https://example.com")); // GOOD
}

// GOOD: scheme check before openUrl
void safe2_qt_scheme_check() {
  char buf[1024];
  read(0, buf, sizeof(buf));
  if (strncmp(buf, "https://", 8) == 0) {
    QDesktopServices::openUrl(QUrl(buf)); // GOOD
  }
}

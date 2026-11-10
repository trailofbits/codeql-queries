#include "../../../include/libc/stdlib.h"
#include "../../../include/libc/string_stubs.h"
#include "../../../include/libc/unistd.h"

struct QString {
  QString(const char *value);
  bool operator==(const char *other) const;
  bool startsWith(const char *prefix) const;
};

struct QUrl {
  QUrl(const char *value);
  QString scheme() const;
};

struct QDesktopServices {
  static bool openUrl(const QUrl &url);
};

void bad_qt() {
  char url[1024];
  read(0, url, sizeof(url));
  QDesktopServices::openUrl(QUrl(url)); // BAD
}

void good_qt_hardcoded() {
  QDesktopServices::openUrl(QUrl("https://example.com")); // GOOD
}

void good_qt_prefix_check() {
  char url[1024];
  read(0, url, sizeof(url));
  if (strncmp(url, "https://", 8) == 0) {
    QDesktopServices::openUrl(QUrl(url)); // GOOD
  }
}

void good_qt_reject_other_prefix() {
  char url[1024];
  read(0, url, sizeof(url));
  if (strncmp(url, "https://", 8) != 0) {
    return;
  }
  QDesktopServices::openUrl(QUrl(url)); // GOOD
}

void good_qt_scheme_check() {
  char value[1024];
  read(0, value, sizeof(value));
  QUrl url(value);
  if (url.scheme() == "https") {
    QDesktopServices::openUrl(url); // GOOD
  }
}

void bad_qt_file_scheme() {
  char url[1024];
  read(0, url, sizeof(url));
  if (strncmp(url, "file://", 7) == 0) {
    QDesktopServices::openUrl(QUrl(url)); // BAD
  }
}

void bad_qt_partial_prefix() {
  char url[1024];
  read(0, url, sizeof(url));
  if (strncmp(url, "https://", 4) == 0) {
    QDesktopServices::openUrl(QUrl(url)); // BAD
  }
}

void bad_qt_rejected_scheme() {
  char url[1024];
  read(0, url, sizeof(url));
  if (strncmp(url, "https://", 8) != 0) {
    QDesktopServices::openUrl(QUrl(url)); // BAD
  }
}

void bad_shell() {
  char url[1024];
  char command[2048];
  read(0, url, sizeof(url));
  sprintf(command, "xdg-open '%s'", url);
  system(command); // BAD
}

void bad_shell_rundll() {
  char url[1024];
  char command[2048];
  read(0, url, sizeof(url));
  sprintf(command, "rundll32 url.dll,FileProtocolHandler '%s'", url);
  system(command); // BAD
}

void bad_shell_open() {
  char url[1024];
  char command[2048];
  read(0, url, sizeof(url));
  sprintf(command, "open '%s'", url);
  system(command); // BAD
}

void good_shell() {
  char url[1024];
  char command[2048];
  read(0, url, sizeof(url));
  if (strncmp(url, "https://", 8) == 0) {
    sprintf(command, "xdg-open '%s'", url);
    system(command); // GOOD
  }
}

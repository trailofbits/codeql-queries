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

#include "themepack.h"

#include <QDesktopServices>
#include <QDir>
#include <QFutureWatcher>
#include <QtConcurrentRun>
#include <QUrl>

namespace {

// Sailfish device path for Android launcher icons; not maintainer-specific.
const char kApkInstalledDir[] = "/home/defaultuser/.local/share/apkd-bridge/launcherIcon";

QStringList missingFilenames(const QString &installedDir, const QString &themedDir)
{
    const QStringList themed = QDir(themedDir).entryList(QDir::Files);
    QStringList missing;

    const QStringList installed = QDir(installedDir).entryList(QDir::Files);
    for (int i = 0; i < installed.size(); ++i) {
        const QString &name = installed.at(i);
        if (!themed.contains(name))
            missing.append(name);
    }

    missing.sort();
    return missing;
}

QString buildIconRequestBody(const QString &packPath)
{
    const QStringList native = missingFilenames(
        QLatin1String("/usr/share/icons/hicolor/86x86/apps"),
        packPath + QLatin1String("/native/86x86/apps"));
    const QStringList apk = missingFilenames(
        QLatin1String(kApkInstalledDir),
        packPath + QLatin1String("/apk/86x86"));

    return QString::fromLatin1(
               "Hi,\n\n"
               "Please consider including the following icons in your theme:\n\n"
               "%1\n"
               "%2\n\n"
               "Regards")
        .arg(native.join(QLatin1String("\n")))
        .arg(apk.join(QLatin1String("\n")));
}

void openIconRequestEmail(const QString &recipient, const QString &subject, const QString &body)
{
    const QString mailto = QString::fromLatin1("mailto:%1?subject=%2&body=%3")
        .arg(recipient)
        .arg(QString::fromLatin1(QUrl::toPercentEncoding(subject).constData()))
        .arg(QString::fromLatin1(QUrl::toPercentEncoding(body).constData()));

    QDesktopServices::openUrl(QUrl(mailto));
}

} // namespace

ThemePack::ThemePack(QObject *parent) : QObject(parent), m_iconRequestWatcher(0)
{
}

void ThemePack::fetchIcons(const QString &packPath,
                           const QString &recipient,
                           const QString &subject)
{
    if (m_iconRequestWatcher)
        return;

    m_pendingRecipient = recipient;
    m_pendingSubject = subject;

    m_iconRequestWatcher = new QFutureWatcher<QString>(this);
    connect(m_iconRequestWatcher, SIGNAL(finished()), this, SLOT(onIconRequestFinished()));
    m_iconRequestWatcher->setFuture(QtConcurrent::run(buildIconRequestBody, packPath));
}

void ThemePack::onIconRequestFinished()
{
    QFutureWatcher<QString> *watcher = m_iconRequestWatcher;
    m_iconRequestWatcher = 0;
    if (!watcher)
        return;

    openIconRequestEmail(m_pendingRecipient, m_pendingSubject, watcher->result());
    watcher->deleteLater();
    emit iconsFetched();
}

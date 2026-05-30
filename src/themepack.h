#ifndef THEMEPACK_H
#define THEMEPACK_H

#include <QObject>
#include <QFutureWatcher>
#include <QString>

class ThemePack : public QObject
{
    Q_OBJECT

public:
    explicit ThemePack(QObject *parent = 0);

    Q_INVOKABLE void fetchIcons(const QString &packPath,
                                const QString &recipient,
                                const QString &subject);

private slots:
    void onIconRequestFinished();

private:
    QFutureWatcher<QString> *m_iconRequestWatcher;
    QString m_pendingRecipient;
    QString m_pendingSubject;

signals:
    void iconsFetched();
};

#endif // THEMEPACK_H

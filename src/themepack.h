#ifndef THEMEPACK_H
#define THEMEPACK_H

#include <QObject>
#include <QFutureWatcher>

class ThemePack : public QObject
{
    Q_OBJECT

public:
    explicit ThemePack(QObject *parent = 0);

public slots:
    void fetchIcons();

private slots:
    void onIconRequestFinished();

private:
    QFutureWatcher<QString> *m_iconRequestWatcher;

signals:
    void iconsFetched();
};

#endif // THEMEPACK_H

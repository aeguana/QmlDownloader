#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QtGlobal>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFile>
#include <QString>


class Downloader : public QObject{
    Q_OBJECT
public:
    explicit Downloader(QObject *parent = 0);
    Q_INVOKABLE void downloadUrl(const QString &);

signals:
    void progress(qint64, qint64);
    void speed(qint64);
    void finished();
    void downloadError(QNetworkReply::NetworkError);

private:
    quint64 m_bytes_available_tally;
    QNetworkAccessManager m_network_manager;
    QNetworkReply *m_network_reply;
    QFile *m_file;

private slots:
    void downloadProgress(qint64, qint64);
    void downloadFinished();
    void downloadReadyRead();
    void error(QNetworkReply::NetworkError);
};

#endif // DOWNLOADER_H

#include <QtDebug>
#include <QFileInfo>
#include <QDateTime>
#include <stdexcept>

#include "downloader.h"


Downloader::Downloader(QObject *parent) :QObject(parent){
    m_bytes_available_tally = 0;
}

void Downloader::downloadUrl(const QString &link){
    QUrl url(link);
    QNetworkRequest request(url);
    QString filename = QFileInfo(url.path()).fileName();

    m_network_reply = m_network_manager.get(request);

    // connect handlers (signals)
    connect(m_network_reply, SIGNAL(downloadProgress(qint64,qint64)), SLOT(downloadProgress(qint64,qint64)));
    connect(m_network_reply, SIGNAL(finished()), SLOT(downloadFinished()));
    connect(m_network_reply, SIGNAL(readyRead()), SLOT(downloadReadyRead()));
    connect(m_network_reply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(error(QNetworkReply::NetworkError)));

    qDebug() << "Downloading " << filename << " ...";

    m_file = new QFile(filename);

    if(!m_file->open(QIODevice::ReadWrite | QIODevice::Truncate)){
        qDebug() << m_file->errorString();
        throw std::runtime_error("Could not open a file to write.");
    }
    QFileInfo info = QFileInfo(*m_file);
    qDebug() << info.absoluteFilePath();
}

void Downloader::downloadProgress(qint64 pos, qint64 total){
    emit progress(pos, total);
}

void Downloader::downloadFinished(){
    m_bytes_available_tally = 0;

    if(m_network_reply->error() == QNetworkReply::NoError){
        qDebug() << "Finished downloading.";
        m_file->close();
        emit finished();
    }
    emit downloadError(m_network_reply->error());
}

void Downloader::downloadReadyRead(){
    if(m_network_reply->error() == QNetworkReply::NoError){
        static quint64 last_ms = QDateTime::currentMSecsSinceEpoch();

        quint64 now_ms = QDateTime::currentMSecsSinceEpoch();
        quint64 diff_ms = now_ms - last_ms;
        double speed_b =  (m_bytes_available_tally * 1000.0) / diff_ms;

        if(diff_ms >= 200){
            last_ms = now_ms;
            m_bytes_available_tally = 0;
            emit speed(quint64(speed_b/1024));
        }

        m_bytes_available_tally += m_network_reply->bytesAvailable();
        m_file->write(m_network_reply->readAll());
    }
}

void Downloader::error(QNetworkReply::NetworkError err){
    qDebug() << "Error: " << err;
    emit downloadError(err);
}



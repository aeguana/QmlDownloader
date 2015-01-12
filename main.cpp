#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "downloader.h"

int main(int argc, char *argv[]){
    QApplication app(argc, argv);

    Downloader *d = new Downloader();

    QQmlApplicationEngine engine;
    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty("downloader", d);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}

#include <QGuiApplication>
#include <QQuickView>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "beep.h"

int main(int argc, char *argv[])
{
   QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
   Beep *m_beep;
   m_beep = new Beep();
   QGuiApplication app(argc, argv);

   QQmlApplicationEngine * engine;
   engine = new QQmlApplicationEngine();
   QQmlContext* rootcontext = engine->rootContext();
   rootcontext->setContextProperty("beeper", m_beep);


   engine->load(QUrl(QStringLiteral("qrc:/mainview.qml")));
   if (engine->rootObjects().isEmpty())
   return -1;

return app.exec();
}

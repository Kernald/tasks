// Tabbed pane project template
#include "Tasks.hpp"

#include <ctime>

#include <bb/cascades/Application>

#include <QtCore/QLocale>
#include <QtCore/QTranslator>
#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;

#ifdef QT_DEBUG
void standardOutput(QtMsgType /*type*/, const char* msg) {
	fprintf(stdout, "%s\n", msg);
	fflush(stdout);
}
#endif // QT_DEBUG

Q_DECL_EXPORT int main(int argc, char **argv) {
    Application app(argc, argv);
#ifdef QT_DEBUG
    qInstallMsgHandler(standardOutput);
#endif // QT_DEBUG
    qsrand(std::time(NULL));

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString("Tasks_%1").arg(locale_string);
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator(&translator);
    }

    new Tasks;

    return Application::exec();
}

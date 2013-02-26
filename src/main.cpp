// Tabbed pane project template
#include "Tasks.hpp"

#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>
#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;

void standardOutput(QtMsgType type, const char* msg) {
	fprintf(stdout, "%s\n", msg);
	fflush(stdout);
}

Q_DECL_EXPORT int main(int argc, char **argv) {
    Application app(argc, argv);
    qInstallMsgHandler(standardOutput);

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

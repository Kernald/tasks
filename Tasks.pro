APP_NAME = Tasks

CONFIG += qt warn_on cascades10

LIBS += -lbbdata

#include(config.pri)

BASEDIR =  $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(debug, debug|release) {
        SOURCES +=  $$quote($$BASEDIR/src/ActiveFrame.cpp) \
                 $$quote($$BASEDIR/src/Tasks.cpp) \
                 $$quote($$BASEDIR/src/TasksDbHelper.cpp) \
                 $$quote($$BASEDIR/src/main.cpp)

        HEADERS +=  $$quote($$BASEDIR/src/ActiveFrame.hpp) \
                 $$quote($$BASEDIR/src/Tasks.hpp) \
                 $$quote($$BASEDIR/src/TasksDbHelper.hpp)
    }

    CONFIG(release, debug|release) {
        SOURCES +=  $$quote($$BASEDIR/src/ActiveFrame.cpp) \
                 $$quote($$BASEDIR/src/Tasks.cpp) \
                 $$quote($$BASEDIR/src/TasksDbHelper.cpp) \
                 $$quote($$BASEDIR/src/main.cpp)

        HEADERS +=  $$quote($$BASEDIR/src/ActiveFrame.hpp) \
                 $$quote($$BASEDIR/src/Tasks.hpp) \
                 $$quote($$BASEDIR/src/TasksDbHelper.hpp)
    }
}

simulator {
    CONFIG(debug, debug|release) {
        SOURCES +=  $$quote($$BASEDIR/src/ActiveFrame.cpp) \
                 $$quote($$BASEDIR/src/Tasks.cpp) \
                 $$quote($$BASEDIR/src/TasksDbHelper.cpp) \
                 $$quote($$BASEDIR/src/main.cpp)

        HEADERS +=  $$quote($$BASEDIR/src/ActiveFrame.hpp) \
                 $$quote($$BASEDIR/src/Tasks.hpp) \
                 $$quote($$BASEDIR/src/TasksDbHelper.hpp)
    }
}

INCLUDEPATH +=  $$quote($$BASEDIR/src)

CONFIG += precompile_header

PRECOMPILED_HEADER =  $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES +=  $$quote($$BASEDIR/../src/*.c) \
             $$quote($$BASEDIR/../src/*.c++) \
             $$quote($$BASEDIR/../src/*.cc) \
             $$quote($$BASEDIR/../src/*.cpp) \
             $$quote($$BASEDIR/../src/*.cxx) \
             $$quote($$BASEDIR/../assets/*.qml) \
             $$quote($$BASEDIR/../assets/AddPage/*.qml) \
             $$quote($$BASEDIR/../assets/AppCover/*.qml) \
             $$quote($$BASEDIR/../assets/TaskPage/*.qml) \
             $$quote($$BASEDIR/../assets/720x720/AppCover/*.qml) \
             $$quote($$BASEDIR/../assets/*.js) \
             $$quote($$BASEDIR/../assets/*.qs)

    HEADERS +=  $$quote($$BASEDIR/../src/*.h) \
             $$quote($$BASEDIR/../src/*.h++) \
             $$quote($$BASEDIR/../src/*.hh) \
             $$quote($$BASEDIR/../src/*.hpp) \
             $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS =  $$quote($${TARGET}_fr.ts) \
         $$quote($${TARGET}.ts)
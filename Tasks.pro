APP_NAME = Tasks

CONFIG += qt warn_on cascades10

LIBS += -lbbdata

include(config.pri)

lupdate_inclusion {
    SOURCES +=  $$quote($$BASEDIR/../assets/AddPage/*.qml) \
             $$quote($$BASEDIR/../assets/AppCover/*.qml) \
             $$quote($$BASEDIR/../assets/TaskPage/*.qml) \
             $$quote($$BASEDIR/../assets/720x720/AppCover/*.qml)
}

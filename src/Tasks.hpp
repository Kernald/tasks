#ifndef __TASKS_HPP__
#define __TASKS_HPP__

#include <QObject>

namespace bb {
	namespace cascades {
		class GroupDataModel;
		class ListView;
	}
}

using namespace bb::cascades;

class TasksDbHelper;

class Tasks : public QObject {

    Q_OBJECT

public:
    Tasks();
    virtual ~Tasks();

    //TODO done
    Q_INVOKABLE void addNewRecord(const QString& title, const QString& description);
    Q_INVOKABLE void updateSelectedRecord(const QString& title, const QString& description, int done);
    Q_INVOKABLE void updateSelectedRecordDoneStatus(int done);
    Q_INVOKABLE void deleteRecord();

private:
    TasksDbHelper*	_dbHelper;
    GroupDataModel*	_dataModel;
    ListView*		_listView;
};

#endif // __TASKS_HPP__

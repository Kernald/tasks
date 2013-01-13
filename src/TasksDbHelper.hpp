#ifndef __TASKS_DB_HELPER_HPP__
#define __TASKS_DB_HELPER_HPP__

#include <QtSql/QtSql>
#include <bb/data/SqlDataAccess>

using namespace bb::data;

class TasksDbHelper {
public:
	TasksDbHelper();
	virtual ~TasksDbHelper();

	QVariantList loadDataBase(const QString& databaseName, const QString& table);
	bool deleteById(QVariant id);
	QVariant insert(QVariantMap map);
	bool update(QVariantMap map);

private:
	bool copyDbToDataFolder(const QString& databaseName);
	bool queryDatabase(const QString& query);

	QSqlDatabase	_db;
	QString			_table;
	QString			_dbNameWithPath;
};

#endif // __TASKS_DB_HELPER_HPP__

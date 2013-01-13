#include "TasksDbHelper.hpp"

using namespace bb::data;

TasksDbHelper::TasksDbHelper() {
}

TasksDbHelper::~TasksDbHelper() {
	if (_db.isOpen()) {
		QSqlDatabase::removeDatabase(_dbNameWithPath);
		_db.removeDatabase("QSQLITE");
	}
}

bool TasksDbHelper::copyDbToDataFolder(const QString& databaseName) {
	QString dataFolder = QDir::homePath();
	QString newFileName = dataFolder + "/" + databaseName;
	QFile newFile(newFileName);

	if (!newFile.exists()) {
		QString appFolder(QDir::homePath());
		appFolder.chop(4);
		QString originalFileName = appFolder + "app/native/assets/sql/" + databaseName;
		QFile originalFile(originalFileName);

		if (originalFile.exists()) {
			return originalFile.copy(newFileName);
		} else {
			qDebug() << "Failed to copy file, database file does not exist.";
			return false;
		}
	}

	return true;
}

QVariantList TasksDbHelper::loadDataBase(const QString& databaseName, const QString& table) {
	QVariantList sqlData;
	if (copyDbToDataFolder(databaseName)) {
		_dbNameWithPath = "data/" + databaseName;
		SqlDataAccess sqlDataAccess(_dbNameWithPath);
		sqlData = sqlDataAccess.execute("SELECT * FROM " + table).value<QVariantList>();

		if (sqlDataAccess.hasError()) {
			DataAccessError err = sqlDataAccess.error();
			qWarning() << "SQL error: type=" << err.errorType() << ": " << err.errorMessage();
			return sqlData;
		}

		_db = QSqlDatabase::addDatabase("QSQLITE", "database_helper_connection");
		_db.setDatabaseName(_dbNameWithPath);
		if (!_db.isValid()) {
			qWarning() << "Could not set database name (" << _dbNameWithPath << ") , probably due to an invalid driver.";
			return sqlData;
		}

		if (!_db.open()) {
			qWarning() << "Could not open database.";
			return sqlData;
		}

		_table = table;
	}

	return sqlData;
}

bool TasksDbHelper::deleteById(QVariant id) {
	if (id.canConvert(QVariant::String))
		return queryDatabase("DELETE FROM " + _table + " WHERE id=" + id.toString());

	qWarning() << "Failed to delete item with id " << id;
	return false;
}

QVariant TasksDbHelper::insert(QVariantMap map) {
	QSqlQuery query(_db);
	query.prepare("INSERT INTO " + _table + " (title, description, done) VALUES(:title, :description, :done)");
	query.bindValue(":title", map["title"]);
	query.bindValue(":description", map["description"]);
	query.bindValue(":done", map["done"].toString());
	query.exec();

	QSqlError err = query.lastError();
	if (err.isValid())
		qWarning() << "SQL error: " << err.text();

	return query.lastInsertId();
}

bool TasksDbHelper::update(QVariantMap map) {
	QSqlQuery query(_db);
	query.prepare("UPDATE " + _table + " SET title=:title, description=:description, done=:done WHERE id=:id");
	query.bindValue(":title", map["title"]);
	query.bindValue(":description", map["description"]);
	query.bindValue(":done", map["done"].toString());
	query.bindValue(":id", map["id"].toString());
	query.exec();

	QSqlError err = query.lastError();
	if (!err.isValid())
		return true;

	qWarning() << "SQL error: " << err.text();
	return false;
}

bool TasksDbHelper::queryDatabase(const QString& query) {
	QSqlQuery sqlQuery(query, _db);
	QSqlError err = sqlQuery.lastError();
	if (err.isValid()) {
		qWarning() << "SQL error for query: " << query << " error: " << err.text();
		return false;
	}
	return true;
}

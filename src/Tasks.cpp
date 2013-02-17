#include "Tasks.hpp"
#include "TasksDbHelper.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/GroupDataModel>
#include <bb/cascades/ListView>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/QmlDocument>

using namespace bb::cascades;

Tasks::Tasks() : QObject() {
	_dbHelper = new TasksDbHelper;
    QmlDocument *qml = QmlDocument::create("asset:///main.qml");
    if (!qml->hasErrors()) {
    	qml->setContextProperty("_taskApp", this);
    	NavigationPane* navigationPane = qml->createRootObject<NavigationPane>();
    	if (navigationPane) {
    		QVariantList sqlData = _dbHelper->loadDataBase("tasks.db", "tasks");
			_dataModel = navigationPane->findChild<GroupDataModel*>("tasksModel");
			_listView = navigationPane->findChild<ListView*>("tasksList");
    		if (!sqlData.isEmpty()) {
    			_dataModel->insertList(sqlData);
    		}

    		Application::instance()->setScene(navigationPane);
    	}
    }
}

Tasks::~Tasks() {
	delete _dbHelper;
}

void Tasks::addNewRecord(const QString& title, const QString& description) {
	QVariantMap map;
	map["title"] = title;
	map["description"] = description;
	map["done"] = 0;

	QVariant insertId = _dbHelper->insert(map);
	if (!insertId.isNull()) {
		map["id"] = insertId;
		_dataModel->insert(map);
	}
}

void Tasks::updateSelectedRecord(const QString& title, const QString& description, int done) {
	QVariantList indexPath = _listView->selected();
	if (!indexPath.isEmpty()) {
		QVariantMap map = _dataModel->data(indexPath).toMap();
		map["title"] = title;
		map["description"] = description;
		map["done"] = done;

		_dbHelper->update(map);
		_dataModel->updateItem(indexPath, map);
	}
}

void Tasks::updateSelectedRecordDoneStatus(int done) {
	QVariantList indexPath = _listView->selected();
	if (!indexPath.isEmpty()) {
		QVariantMap map = _dataModel->data(indexPath).toMap();
		map["done"] = done;

		_dbHelper->update(map);
		_dataModel->updateItem(indexPath, map);
	}
}

void Tasks::deleteRecord() {
	QVariantList indexPath = _listView->selected();
	if (!indexPath.isEmpty()) {
		QVariantMap map = _dataModel->data(indexPath).toMap();
		if (_dbHelper->deleteById(map["id"]))
			_dataModel->remove(map);
	}
}

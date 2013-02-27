#include "Tasks.hpp"

#include "ActiveFrame.hpp"
#include "TasksDbHelper.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/GroupDataModel>
#include <bb/cascades/ListView>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/QmlDocument>
#include <QtCore/QMap>

using namespace bb::cascades;

Tasks::Tasks() : QObject() {
	_dataModel = NULL;
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
    		setCover();
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
		deleteRecord(indexPath);
	}
}

void Tasks::deleteRecord(QVariantList indexPath) {
	QVariantMap map = _dataModel->data(indexPath).toMap();
	if (_dbHelper->deleteById(map["id"]))
		_dataModel->remove(map);
}

void Tasks::deleteRecords(const QVariantList& selectionList) {
    if (selectionList.at(0).canConvert<QVariantList>()) {
        for (int i = selectionList.count() - 1; i >= 0; i--) {
            QVariantList indexPath = selectionList.at(i).toList();
            deleteRecord(indexPath);
        }
    } else {
    	deleteRecord(selectionList);
    }
}

unsigned int Tasks::taskCount() const {
	return _dataModel != NULL ? _dataModel->size() : 0;
}

unsigned int Tasks::doneTaskCount() const {
	unsigned int ret = 0;
	if (_dataModel) {
		for (int i = 0; i < _dataModel->size(); ++i) {
			QVariantList vlo;
			vlo << i;
			for (int j = 0; j < _dataModel->childCount(vlo); ++j) {
				QVariantList vl;
				vl << i << j;
				QMap<QString, QVariant> item = _dataModel->data(vl).toMap();
				if (item.contains("done") && item.value("done") == 1)
					++ret;
			}
		}
	}
	return ret;
}

unsigned int Tasks::todoTaskCount() const {
	return taskCount() - doneTaskCount();
}

QString Tasks::randomTodoTask() const {
	unsigned int todoCount = todoTaskCount();
	if (todoCount > 0) {
		int id = qrand() % todoCount;
		int count = -1;
		for (int i = 0; i < _dataModel->size(); ++i) {
			QVariantList vlo;
			vlo << i;
			for (int j = 0; j < _dataModel->childCount(vlo); ++j) {
				QVariantList vl;
				vl << i << j;
				QMap<QString, QVariant> item = _dataModel->data(vl).toMap();
				if (item.contains("done") && item.value("done") == 0) {
					++count;
					if (count == id)
						return item.value("title").toString();
				}
			}
		}
	}
	return tr("Nothing to do!");
}

void Tasks::setCover() {
	Application::instance()->setCover(new ActiveFrame(this));
}

#include "ActiveFrame.hpp"

#include "Tasks.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/Container>
#include <bb/cascades/Label>
#include <bb/cascades/QmlDocument>

ActiveFrame::ActiveFrame(Tasks* app) : SceneCover(this), _app(app) {
	bb::cascades::QmlDocument* qml = bb::cascades::QmlDocument::create("asset:///AppCover/AppCover.qml").parent(this);
	bb::cascades::Container* c = qml->createRootObject<bb::cascades::Container>();
	setContent(c);
	_count = c->findChild<bb::cascades::Label*>("count");
	_random = c->findChild<bb::cascades::Label*>("randomTask");
	connect(bb::cascades::Application::instance(), SIGNAL(thumbnail()), this, SLOT(update()));
}

ActiveFrame::~ActiveFrame() {}

void ActiveFrame::update() {
	_count->setText(tr("Done tasks: %1/%2").arg(_app->doneTaskCount()).arg(_app->taskCount()));
	_random->setText(_app->randomTodoTask());
}

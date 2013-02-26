#ifndef __ACTIVE_FRAME_HPP__
#define __ACTIVE_FRAME_HPP__

class Tasks;

namespace bb {
	namespace cascades {
		class Label;
	}
}

#include <bb/cascades/SceneCover>

class ActiveFrame: public bb::cascades::SceneCover {

	Q_OBJECT

public:
	ActiveFrame(Tasks* app);
	virtual ~ActiveFrame();

	Q_SLOT void update();

private:
	Tasks*					_app;
	bb::cascades::Label*	_count;
	bb::cascades::Label*	_random;
};

#endif // __ACTIVE_FRAME_HPP__

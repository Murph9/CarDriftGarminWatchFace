using Toybox.WatchUi;

// This class bridges communication between the app and the animation
// playback
class CarDriftAnimationDelegate extends WatchUi.AnimationDelegate {
    var _controller;

	// Constructor
    function initialize() {
        AnimationDelegate.initialize();
    }

    function setController(controller) {
        _controller = controller;
    }

	// Animation event handler
    function onAnimationEvent(event, options) {
        switch(event) {
            case WatchUi.ANIMATION_EVENT_COMPLETE:
                _controller.loop();
                break;
            case WatchUi.ANIMATION_EVENT_CANCELED:
                _controller.stop();
                break;
        }
    }
}
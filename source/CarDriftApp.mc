import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class CarDriftApp extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new CarDriftView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}

function getApp() as CarDriftApp {
    return Application.getApp() as CarDriftApp;
}
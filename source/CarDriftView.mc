import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CarDriftView extends WatchUi.WatchFace {

    var _animationDelegate = null;
    var _playing;
    var _batteryImage;
    var _heartImage;

    function initialize() {
        WatchFace.initialize();

        _animationDelegate = new CarDriftAnimationController();

        _batteryImage = Application.loadResource(Rez.Drawables.battery) as BitmapResource;
        _heartImage = Application.loadResource(Rez.Drawables.heart) as BitmapResource;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _animationDelegate.handleOnShow(self);
        _animationDelegate.play();
    }

    // Function to render the text layer
    private function updateTextLayer() {
        var dc = _animationDelegate.getTextLayer().getDc();
        var width = dc.getWidth();
        var height = dc.getHeight();

        // Clear the layer contents
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();

        // Draw the time in the middle
        var timeString = DataFetcher.getTimeString();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 2, Graphics.FONT_NUMBER_HOT, timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Date above time
        var dateString = DataFetcher.getDate();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, (height / 3f), Graphics.FONT_SMALL, dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var iconSize = 30/2;
        // Battery Percentage on the sides
        dc.drawBitmap((1.2f * width / 4) - iconSize, (height / 1.5f) - iconSize, _batteryImage);
        var batteryString = DataFetcher.getBatteryPercentage();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((1.2f * width / 4) + iconSize, height / 1.5f, Graphics.FONT_TINY, batteryString,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw the Heart Rate on the other side
        dc.drawBitmap((2.8f * width / 4) - iconSize, (height / 1.5f) - iconSize, _heartImage);
        var hrString = DataFetcher.getHeartRate();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((2.8f * width / 4) - iconSize, height / 1.5f, Graphics.FONT_TINY, hrString,
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear the screen buffer
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

        // Update the contents of the text layer
        updateTextLayer();

        return;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        _animationDelegate.handleOnHide(self);
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        _animationDelegate.play();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        _animationDelegate.stop();
    }
}

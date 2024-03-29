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
    var _footprintsImage;

    function initialize() {
        WatchFace.initialize();

        // TODO maybe skid marks
        _animationDelegate = new CarDriftAnimationController();

        _batteryImage = Application.loadResource(Rez.Drawables.battery) as BitmapResource;
        _heartImage = Application.loadResource(Rez.Drawables.heart) as BitmapResource;
        _footprintsImage = Application.loadResource(Rez.Drawables.footprints) as BitmapResource;
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

        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw the time in the middle
        var timeString = DataFetcher.getTimeString();
        dc.drawText(width / 2, height / 2, Graphics.FONT_NUMBER_HOT, timeString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Date above time
        var dateString = DataFetcher.getDate();
        dc.drawText(width / 2, (height / 3f), Graphics.FONT_SMALL, dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Day of week above it
        var dayOfWeekString = DataFetcher.getDayOfWeek();
        dc.drawText(width / 2, (height / 3.9f), Graphics.FONT_XTINY, dayOfWeekString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var iconSize = 30/2;
        // Battery Percentage on the sides
        dc.drawBitmap((1.2f * width / 4) - iconSize, (height / 1.5f) - iconSize, _batteryImage);
        var batteryString = DataFetcher.getBatteryPercentage();
        dc.drawText((1.2f * width / 4) + iconSize, height / 1.5f, Graphics.FONT_TINY, batteryString,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw the Heart Rate on the other side
        dc.drawBitmap((2.8f * width / 4) - iconSize, (height / 1.5f) - iconSize, _heartImage);
        var hrString = DataFetcher.getHeartRate();
        if (hrString != null) {
            dc.drawText((2.8f * width / 4) - iconSize, height / 1.5f, Graphics.FONT_TINY, hrString,
                Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Steps below it all
        dc.drawBitmap((width / 2) - iconSize, (height * .82f) - iconSize, _footprintsImage);
        var stepsString = DataFetcher.getSteps();
        dc.drawText(width / 2, (height * .75f), Graphics.FONT_XTINY, stepsString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        
        // Attempt to overlay the same colour to match everything with the same colour
        // dc.setBlendMode(Graphics.BLEND_MODE_MULTIPLY);
        // dc.setFill(0x88FF0000);
        // dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        // dc.fillCircle(208, 208, 208);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear the screen buffer
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
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

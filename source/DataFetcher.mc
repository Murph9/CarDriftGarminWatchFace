import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Time;
import Toybox.SensorHistory;
import Toybox.System;

class DataFetcher {

    public static function getDayOfWeek() {
        var date = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return date.day_of_week.toString();
    }

    public static function getDate() {
        var date = Time.Gregorian.info(Time.now(),0);
        var day = date.day;
        var month = date.month;
        var month_str = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM).month;
        return day.toString() + " " + month_str.toUpper().substring(0,3);
    }

    
    public static function getTimeString() {
        var clockTime = System.getClockTime();
        var info = System.getDeviceSettings();

        var hour = clockTime.hour;

        if( !info.is24Hour ) {
            hour = clockTime.hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        return Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
    }
     
    public static function getSteps() {
        var info = ActivityMonitor.getInfo();
        return info.steps.toString();
    }

    public static function getHeartRate() {
        var activity = Activity.getActivityInfo();
        var heartrate = activity.currentHeartRate;
        if (heartrate == null) {
            return "ded";
        }
        return heartrate.toNumber();
    }

    public static function getBatteryPercentage() {
        var value = System.getSystemStats().battery;
        if (value.toNumber() == 69) {
            return "nice";
        }
        return value.toNumber() + "%";
    }

    public static function getLatestStress() {
        if (!(Toybox has :SensorHistory) || !(Toybox.SensorHistory has :getStressHistory)) {
            return null;
        }
        var stressIterator = SensorHistory.getStressHistory({}); // already newest first
        var sample = stressIterator.next();
        if (sample == null) {
            return null;
        }
        return sample.data.format("%d");
    }
}

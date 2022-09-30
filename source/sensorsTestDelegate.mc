import Toybox.Lang;
import Toybox.WatchUi;

class sensorsTestDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new sensorsTestMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
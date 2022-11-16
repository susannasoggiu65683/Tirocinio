import Toybox.Lang;
import Toybox.WatchUi;

class SwimCraDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SwimCraMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
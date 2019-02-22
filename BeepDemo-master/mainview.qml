import QtQuick 2.3
import QtQuick.Window 2.0

Window {
    visible: true

    title: qsTr("Sciton Joule-X")
    width: 1024
    height: 768
    /*!
        property used so we don't send out a screen echo on first load
   */
    property bool firstLoad : true
    property string backgroundColor: "#e0f1fa"

    Image{
        source: "images/g2h2/scrnCenterSciton.png"
    }

    Loader{
        id: loader
        focus: true

        onStatusChanged: {
            if (status == Loader.Error)
            {
                source = "error.qml"
            }
            else if (status == Loader.Ready)
            {
                 if (! firstLoad)
                     echoScreenToMCU(loader.item.screenID, "00000")
            }
        }
    }
    Component.onCompleted: {
        beeper.init();
        beeper.setVolume(70);   // Style.loudness
        if (typeof(connection) == 'undefined') {
            // LinuxVM
            beeper.openwave("/application/src/sounds/range.wav");
        }
        else {
            // Display module
            beeper.openwave("/application/src/sounds/sci_fi_beep_off.wav");
            beeper.play();
        }
        // restore to default settings
        beeper.setVolume(100);  //set to 100% volume [0..100]
        ////settings.setValue("loudness", Style.loudness);
        beeper.openwave("/application/src/sounds/Plastic Button 17.wav");
        //Load the menu as the initial screen
        beeper.play();
        beeper.openwave("/application/src/sounds/Chime musical_BLASTWAVEFX_16359.wav")
        beeper.play();
        beeper.openwave("application/src/sounds/SW001_8-Bit-Games-191_Pickup_Coin.wav")
        beeper.play()
        loader.source =   "demo.qml";   // "ScitonTemplate.qml"  //
        firstLoad = false;
        timestamplog("Beep Demo")
    }
    function echoScreenToMCU(screenID, screenValue)
     {
         if (typeof connection == 'undefined')
             loader.source = "qrc:/demo.qml"
         else
             connection.sendMessage(qsTr("s%1=%2").arg(screenID).arg(screenValue));
     }
    function addZero(x,n) {
      while (x.toString().length < n) {
        x = "0" + x;
      }
      return x;
    }
    function timestamplog(msg) {
      var d = new Date();
      var h = addZero(d.getHours(), 2);
      var m = addZero(d.getMinutes(), 2);
      var s = addZero(d.getSeconds(), 2);
      var ms = addZero(d.getMilliseconds(), 3);
        console.log(h + ":" + m + ":" + s + ":" + ms + "--" + msg);
    }
}

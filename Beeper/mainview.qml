import QtQuick 2.9
import QtQuick.Window 2.2

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
//    Use WorkerScript to run operations in a new thread.
//    This is useful for running operations in the background so that the main GUI thread is not blocked.
//    Messages can be passed between the new thread and the parent thread using sendMessage() and the onMessage() handler.
    WorkerScript {
        id: backgroundBeeper

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
            //beeper.openwave("/home/reach/VMShare/qmlscene/button.wav");  // default audio for button press
            beeper.openwave("/home/reach/VMShare/qmlscene/range.wav");
        }
        else {
            // Display module
            beeper.openwave("/application/src/sounds/range.wav");
            beeper.play();
        }
        // restore to default settings
        ////beeper.setVolume(Style.loudness);  //set to 100% volume [0..100]
        ////settings.setValue("loudness", Style.loudness);
        beeper.openwave("/application/src/sounds/button.wav");
        //Load the menu as the initial screen
        loader.source =   "ScitonScreen.qml";   // "ScitonTemplate.qml"  //
        firstLoad = false;
    }
    function echoScreenToMCU(screenID, screenValue)
     {
         if (typeof connection == 'undefined')
             loader.source = "qrc:/bblManualMode.qml"
         else
             connection.sendMessage(qsTr("s%1=%2").arg(screenID).arg(screenValue));
     }
}

import QtQuick 2.0

import "."
/*!
    \Audio.qml
*/

Item {
    id: root

    property int startaudio: 0
    property int piezovolume: 150   // given raw value by the controller [-1..255]
    property int audiophile: -1     // p98: UI_MSG_P_AUDIOPHILE
    property real loudness: 70     // audio plugin sees: percentage [1..100], audible [40..100]

    onPiezovolumeChanged: {
        if ( (piezovolume >= 20) && (piezovolume <= 257)) {
                loudness = piezovolume/2.4; // rescale it to the beeper plugin range in percentage
                beeper.setVolume(loudness);
                //Style.loudness = loudness;
                settings.setValue("loudness", loudness);
//                echoPropertyToMCU(1425, settings.getValue("loudness"));
        }
        else
            ;
    }
    onStartaudioChanged: {
        if (startaudio == 1)
            beeper.play();
        startaudio = 0;
    }

    onAudiophileChanged: {
//        echoPropertyToMCU(98, audiophile);
        if (audiophile > -1) {
            switch (audiophile) {
            case 0:
//                beeper.setVolume(80);
                if (typeof(connection) == 'undefined')
                    beeper.openwave("/home/reach/VMShare/qmlscene/button.wav");  // default audio for button press
                else {
//                    beeper.setDuration(2000);
                    beeper.openwave("/application/src/sounds/button.wav");
                }
                break;
             case 1:     //chirpping
                beeper.openwave("/application/src/sounds/limit.wav");   // range limit
//                beeper.setVolume(90);
//                beeper.setDuration(9000);
                beeper.play();
                break;
             case 2: // it's not neccessary a warning sound
                beeper.openwave("/application/src/sounds/longbeep.wav");
//                beeper.setVolume(90);
                beeper.play();
                break;
             case 98:
                 startaudio = 1;
                 break;
             case 99:
                 beeper.openwave("/application/src/sounds/dual.wav");    // Halo app
                 beeper.play();
                 break;
             default:
                 beeper.openwave("/application/src/sounds/button.wav");
                 break;
            }
        }
        audiophile = 0;     // reset to normal button sound profile
    }

    Component.onCompleted: {
    }
}

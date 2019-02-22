import QtQuick 2.3

Rectangle {
    property var locale: Qt.locale()
     property date currentTime: new Date()
     property string timeString
    visible: true
    width: 480
    height: 272
    color: "#222222"
    Rectangle {
        id: rec1
        x: 345
        y: 39
        property bool on: true
        width: 100
        height: 100
        color: "red"

        MouseArea {
            anchors.fill: parent

            onPressed: {
                rec1.on = !rec1.on
                if (rec1.on) {
                    timestamplog("Loading beep1.wav")
                    rec1.color = "red"
                    beeper.openwave("/application/src/sounds/Chime_muc.wav")
                    beeper.play()
                } else {
                    timestamplog("Loading button.wav")
                    rec1.color = "green"
                    beeper.openwave("/application/src/sounds/Plastic_Button_17.wav")
                    beeper.play()
                }
            }
        }
    }

    Rectangle {
        id: rec2
        property bool on: true
        x: 190
        y: 144
        width: 100
        height: 100
        color: "white"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                rec2.on = !rec2.on
                if (rec2.on) {
                    timestamplog("Loading ding.wav")
                    rec2.color = "white"
                    beeper.openwave("/application/src/sounds/sci_fi_beep_off.wav")
                    beeper.play()
                } else {
                    timestamplog("Loading handpiece.wav")
                    rec2.color = "purple"
                    beeper.openwave("/application/src/sounds/SW001_8-Bit-Games-191_Pickup_Coin.wav")
                    beeper.play()
                }
            }
        }
    }

    Rectangle {
        id: rec3
        x: 27
        y: 39
        width: 100
        height: 100
        property bool on: true
        color: "blue"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                rec3.on = !rec3.on
                if (rec3.on) {
                    timestamplog("Loading limit.wav")
                    rec3.color = "blue"
                    beeper.openwave("/application/src/sounds/limit.wav")
                    beeper.play()
                } else {
                    timestamplog("Loading longbeep.wav")
                    rec3.color = "yellow"
                    beeper.openwave("/application/src/sounds/longbeep.wav")
                    beeper.play()
                }
            }
        }
    }
    Component.onCompleted: {
        timeString = currentTime.toLocaleTimeString(locale);
        console.log(timeString);
        timestamplog("Demo.qml loaded")
        beeper.openwave("/application/src/sounds/sine2k.wav")
        beeper.play()
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

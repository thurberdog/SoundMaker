import QtQuick 2.0
import "."
/* CodeEntry.qml */

Rectangle {
    id: codeEntry
    width: 400; height: 450
    color: "#00000000"
    radius: 0
    border.color: "#00000000"
    border.width: 0

    property int codelength: 4
    property string accumulator: "???"
    property string passwordHidden: "*"
    property var code: ""

    property int xPos: 6
    property int yPos: 0
    property int gapPos: 80


    Rectangle {
        id: entrybox
        width: 226
        height: 43
        radius: 8
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 0
        color: "white"

        property int countdown: 0
        property var hiddenStr: ""
        x: 12

        onCountdownChanged: {
            if (entry.text.length == 4)
                entry.text = entrybox.hiddenStr;
        }

        MouseArea {
            id: btnShowEntry
            x: 0
            width: entrybox.width
            height: entrybox.height
            anchors.top: parent.top
            anchors.topMargin: 0
            onPressed: {
            }
        }
        Timer {
            id: elapse
            triggeredOnStart: false
            interval: 1000
            repeat: true
            running: btnShowEntry.pressed

            onTriggered: {
                entrybox.countdown++;
                if (entrybox.countdown > 5)
                {
                    entrybox.countdown = 0;
                    running = false;
                }
            }
        }
        TextCtl {
            id: entry
            x: 0;
            width: entrybox.width
            height: entrybox.height
            text: ""
            anchors.top: parent.top
            anchors.topMargin: 5
            textColor: "gray"
            wrapMode: 0
            pointSize: 30
        }
    }

    Rectangle {
        id: promptBox
        x: 3
        width: 350
        height: 38
        color: "#00000000"
        anchors.top: entrybox.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        TextCtl {
            id: prompt
            x: 0
            width: promptBox.width
            height: promptBox.height
            text: "Please Enter Password"
            anchors.top: parent.top
            anchors.topMargin: 0
            wrapMode: 0
            pointSize: 14
            textColor: "#000000"
        }
        TextCtl {
            id: prompt_reset
            x: 0
            width: promptBox.width
            height: promptBox.height
            text: ""
            anchors.top: parent.top
            anchors.topMargin: 0
            wrapMode: 0
            pointSize: 10
        }
    }

    Rectangle {
        id: guard
        x: 10;
        width: 240
        height: 330
        color: "#00000000"
        anchors.top: promptBox.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "#00000000"
        visible: true

        ImageButton {
            id: btn1
            x: xPos
            y: yPos
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button1.png"
            imageDown: "../images/g2h2/keypad/button1.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "1";
               }
            }
        }
        ImageButton {
            id: btn2
            x: btn1.x+gapPos;
            y: btn1.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button2.png"
            imageDown: "../images/g2h2/keypad/button2.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
                if ( entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "2";
                }
            }
        }
        ImageButton {
            id: btn3
            x: btn2.x+gapPos
            y: btn2.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button3.png"
            imageDown: "../images/g2h2/keypad/button3.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "3";
               }
            }
        }
        ImageButton {
            id: btn4
            x: xPos
            y: btn1.y+gapPos
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button4.png"
            imageDown: "../images/g2h2/keypad/button4.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "4";
               }
            }
        }
        ImageButton {
            id: btn5
            x: btn4.x+gapPos
            y: btn4.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button5.png"
            imageDown: "../images/g2h2/keypad/button5.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "5";
               }
            }
        }
        ImageButton {
            id: btn6
            x: btn5.x+gapPos
            y: btn5.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button6.png"
            imageDown: "../images/g2h2/keypad/button6.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "6";
               }
            }
        }
        ImageButton {
            id: btn7
            x: xPos
            y: btn4.y+gapPos
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button7.png"
            imageDown: "../images/g2h2/keypad/button7.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "7";
               }
            }
        }
        ImageButton {
            id: btn8
            x: btn7.x+gapPos
            y: btn7.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button8.png"
            imageDown: "../images/g2h2/keypad/button8.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "8";
               }
            }
        }
        ImageButton {
            id: btn9
            x: btn8.x+gapPos
            y: btn8.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button9.png"
            imageDown: "../images/g2h2/keypad/button9.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "9";
               }
            }
        }
        ImageButton {
            id: btn0
            x: btn8.x
            y: btn8.y+gapPos
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/button0.png"
            imageDown: "../images/g2h2/keypad/button0.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
               if (entry.text.length < codelength) {
                    entry.text += passwordHidden;
                    entrybox.hiddenStr += "0";
               }
            }
        }

        ImageButton {
            id: btnClear
            x: xPos
            y: btn0.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/buttonClear.png"
            imageDown: "../images/g2h2/keypad/buttonClear.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
                clearEntry();
                prompt.text ="Please enter password"
                prompt.textColor = "#000000"
            }
        }
        ImageButton {
            id: btnEnter
            x: btn0.x+gapPos
            y: btn0.y
            width: 70;  height: 70
            imageUp: "../images/g2h2/keypad/buttonEnter.png"
            imageDown: "../images/g2h2/keypad/buttonEnter.png"
            releaseEventId: 0
            onButtonRelease: {
                startaudio = 1;
                if (entry.text.length == 4) {
                    code = settings.getValue("user");   // user code
                    if (entrybox.hiddenStr.match(code) ||
                           entrybox.hiddenStr.match("0925") )   // bp code
                    {
                        accumulator = "1040";
                        prompt.text = "Please wait for System to finish its initialization ..."
                        prompt.textColor = "#000000"
                        guard.visible = false;
                    }
                    else {
                        prompt.text ="Invalid password. Try again."
                        prompt.textColor = "#f14b54"
                        clearEntry();
                    }
                }
                else {
                    prompt.text ="Please Enter Password."
                }
            }
        }
    }
    function clearEntry()
    {
        entry.text = "";   // clear all
        entrybox.hiddenStr = "";
    }

}

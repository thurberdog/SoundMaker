import QtQuick 2.0
import "components"


/*!
    bblManualMode Screen
        this is a generic screen shared by several application including Manual Mode
        */
ScreenFLuenceWidthTemperature {
    id: screen
    objectName: "screen"
    screenID: 224
    title: "BroadBand Light"
    btnPrevious_Enable: true
    timeRepeatVisible: true

    property int memRowPos: 540

    property alias blinkLaserSym: screen.imgEnable // p89: UI_MSG_P_BLINKLASERSYM

    property alias genericData1: groupSELECTMEMSTO.ctlVisible // p25: UI_MSG_P_MEMSTO show the strip
    property alias genericData5: groupSELECTMEMRCL.ctlVisible // p29: UI_MSG_P_MEMRCL show the strip
    property alias genericData2: btnSELECTMEMSTO1.text // p26: UI_MSG_P_MEMSTO1
    property alias genericData3: btnSELECTMEMSTO2.text // p27: UI_MSG_P_MEMSTO2
    property alias genericData4: btnSELECTMEMSTO3.text // p28: UI_MSG_P_MEMSTO3
    property alias genericData6: btnSELECTMEMRCL1.text // p30: UI_MSG_P_MEMRCL1
    property alias genericData7: btnSELECTMEMRCL2.text // p31: UI_MSG_P_MEMRCL2
    property alias genericData8: btnSELECTMEMRCL3.text // p32: UI_MSG_P_MEMRCL3

    property int generic130: -1                         // p130

    property alias pulseMode: btnMode.val // p12: UI_MSG_P_BBLPULSEMODE

    onPulseModeChanged: {
        // p12: UI_MSG_P_BBLPULSEMODE
        if (pulseMode >= 0) {
            btnMode.imageUp = btnMode.pulsemodeArray[pulseMode]
            btnMode.imageDown = btnMode.pulsemodeArray[pulseMode]
        }
    }

    onGeneric130Changed: {
        btnSELECTMEMSTO1.opacity = 0.3;
        btnSELECTMEMSTO2.opacity = 0.3;
        btnSELECTMEMSTO3.opacity = 0.3;
        btnSELECTMEMRCL1.opacity = 0.3;
        btnSELECTMEMRCL2.opacity = 0.3;
        btnSELECTMEMRCL3.opacity = 0.3;
        switch (generic130) {
        case 1:
            btnSELECTMEMSTO1.opacity = 1.0;
            break;
        case 2:
            btnSELECTMEMSTO2.opacity = 1.0;
            break;
        case 3:
            btnSELECTMEMSTO3.opacity = 1.0;
            break;
        case 5:
            btnSELECTMEMRCL1.opacity = 1.0;
            break;
        case 6:
            btnSELECTMEMRCL2.opacity = 1.0;
            break;
        case 7:
            btnSELECTMEMRCL3.opacity = 1.0;
            break;
        default:
            break;

        }
    }

    onGenericData1Changed: {
        groupSELECTMEMRCL.visible = false;
        btnSELECTMEMRCL1.opacity = 0.3;
        btnSELECTMEMRCL2.opacity = 0.3;
        btnSELECTMEMRCL3.opacity = 0.3;
        if (genericData1 == 1) {
            groupSELECTMEMSTO.visible = true;
        } else {
            groupSELECTMEMSTO.visible = false;
        }
    }
    onGenericData5Changed: {
        groupSELECTMEMSTO.visible = false;
        btnSELECTMEMSTO1.opacity = 0.3;
        btnSELECTMEMSTO2.opacity = 0.3;
        btnSELECTMEMSTO3.opacity = 0.3;
        if (genericData5 == 1) {
            groupSELECTMEMRCL.visible = true;
        } else {
            groupSELECTMEMRCL.visible = false;
        }
    }

    ImageButton {
        id: btnMode
        x: 550
        y: 350
        width: 120
        height: 100
        imageUp: "qrc:/images/g2h2/BBL/bblMode1.png"
        imageDown: "qrc:/images/g2h2/BBL/bblMode1.png"
        property int val: -1
        property var pulsemodeArray: ["./images/g2h2/bbl/bblMode1.png", "./images/g2h2/bbl/bblMode2.png", "./images/g2h2/bbl/bblMode3.png"]
        releaseEventId: 10
    }

    Rectangle {
        id: rect_memorybuttons
        x: 340
        y: 473
        width: 330
        height: 179
        color: "#00000000"
        anchors.horizontalCenter: parent.horizontalCenter
        ImageButton {
            id: btnSELECTMEMSTO
            y: memRowPos
            width: 81
            height: 62
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 0
            imageUp: "images/g2h2/BBLMstoreButton.png"
            imageDown: "images/g2h2/BBLMstoreButton.png"
            releaseEventId: 17
        }
        Item {
            id: groupSELECTMEMSTO
            y: memRowPos
            height: 170
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 120
            visible: false
            opacity: 1.0

            property int ctlVisible: -1

            ImageButton {
                id: btnSELECTMEMSTO1
                width: 120
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: btnSELECTMEMSTO2.top
                anchors.bottomMargin: 10
                opacity: 0.3
                imageUp: "images/BBL/537_btn1.bmp"
                imageDown: "images/BBL/537_btn1.bmp"
                textFontPixel: 18
                releaseEventId: 18
            }
            ImageButton {
                id: btnSELECTMEMSTO2
                width: 120
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.3
                imageUp: "images/BBL/538_btn2.bmp"
                imageDown: "images/BBL/538_btn2.bmp"
                textFontPixel: 18
                releaseEventId: 19
            }
            ImageButton {
                id: btnSELECTMEMSTO3
                width: 120
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: btnSELECTMEMSTO2.bottom
                anchors.topMargin: 10
                opacity: 0.3
                imageUp: "images/BBL/539_btn3.bmp"
                imageDown: "images/BBL/539_btn3.bmp"
                textFontPixel: 18
                releaseEventId: 20
            }
        }

        ImageButton {
            id: btnSELECTMEMRCL
            x: 896
            y: memRowPos
            width: 81
            height: 62
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            imageUp: "images/g2h2/BBLMrecallButton.png"
            imageDown: "images/g2h2/BBLMrecallButton.png"
            releaseEventId: 21
        }

        Item {
            id: groupSELECTMEMRCL
            x: 539
            y: memRowPos
            height: 170
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: 120
            visible: false
            opacity: 1.0

            property int ctlVisible: -1

            ImageButton {
                id: btnSELECTMEMRCL1
                width: 120
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: btnSELECTMEMRCL2.top
                anchors.bottomMargin: 10
                opacity: 0.3
                imageUp: "images/BBL/537_btn1.bmp"
                imageDown: "images/BBL/537_btn1.bmp"
                x: 125
                y: 2
                textFontPixel: 18
                releaseEventId: 22
            }
            ImageButton {
                id: btnSELECTMEMRCL2
                x: 200
                y: 2
                width: 120
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.3
                imageUp: "images/BBL/538_btn2.bmp"
                imageDown: "images/BBL/538_btn2.bmp"
                textFontPixel: 18
                releaseEventId: 23
            }
            ImageButton {
                id: btnSELECTMEMRCL3
                x: 276
                y: 2
                width: 120
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: btnSELECTMEMRCL2.bottom
                anchors.topMargin: 10
                opacity: 0.3
                textFontPixel: 18
                imageUp: "images/BBL/539_btn3.bmp"
                imageDown: "images/BBL/539_btn3.bmp"
                releaseEventId: 24
            }
        }
    }
    Component.onCompleted: {

    }
}

import QtQuick 2.0
import "."
/*!
    Adapter1Reminder.qml
    \inqmlmodule components
    \brief A warning message to be displayed when screen id = 222.
*/

Rectangle{
    id: adapter1Reminder
    width: 1024
    height: 768
    color: "transparent"
    /*!
        An event id to send to MCU to close the warning message.
    */
    property int eventID
    property alias adapterID:  recInner.adapterID
    /*!
        signal to hook into to close the warning screen
    */
    signal close();

    /*!
        MouseArea used to prevent a user from clicking any other buttons on the parent screen.
    */
    Rectangle {
        id: rectangle1
        width: 1024
        height: 640
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        border.width: 0
        opacity: 0.6
        MouseArea{
            x: 0
            y: 0
            width: 1024
            height: 650
        }
    }

    Rectangle {
        id: recInner
        x: 254
        y: 231
        width: 530
        height: 360
        color: bannerColor
        radius: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        property int adapterID: -1
        property var adapters: ["../images/g2h2/BBL/217_Adaptersmallsqrgold.png",
                                "../images/g2h2/BBL/217_btnAdaptersmallspot.png"]
        onAdapterIDChanged: {
            if (adapterID == 0 || adapterID == 1)
                imgAdapter.source = adapters[adapterID];
        }

        TextCtl {
            id: txtwarning
            x: 0
            y: 0
            height: 40
            anchors.top: recInner.top
            anchors.topMargin: 30
            anchors.horizontalCenter: recInner.horizontalCenter
            pointSize: 24
            text: "Warning"
            textColor: "#ffffff"
            anchors.horizontalCenterOffset: 0
        }

        Image{
            id: imgAdapter
            width: 147
            height: 60
            anchors.horizontalCenterOffset: 0
            anchors.top: txtwarning.bottom
            anchors.topMargin: 23
            anchors.horizontalCenter: recInner.horizontalCenter
            source: ""
         }

        TextCtl {
            id: txtMessage
            y: 144
            width: 2
            height: 80
            anchors.top: txtwarning.bottom
            anchors.topMargin: 100
            anchors.horizontalCenter: recInner.horizontalCenter
            text: "To avoid adverse effects, please use\n a small adapter."
            font_bold: false
            pointSize: 16
            textColor: "#ffffff"
            wrapMode: 0
        }

        /*!
                A button that will send an event to the MCU so it can be closed.
         */
        ImageButton{
            id: btnClose
            anchors.top: txtMessage.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: recInner.horizontalCenter
            imageUp: imgPath + "099_Back.png"
            imageDown: imgPath + "099_Back.png"
            width: 85
            height: 57
            anchors.horizontalCenterOffset: 1
            releaseEventId: eventID
        }
    }
}


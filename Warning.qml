import QtQuick 2.0
import "."
/*!
    Warning.qml
    \inqmlmodule components
    \brief A warning message to be displayed when screen id = 222.
*/

Rectangle{
    id: warning
    width: 1024
    height: 768
    color: "transparent"
    /*!
        An event id to send to MCU to close the warning message.
    */
    property int eventID

    /*!
        signal to hook into to close the warning screen
    */
    signal close();

    /*!
        MouseArea used to prevent a user from clicking any other buttons on the parent screen.
    */
    MouseArea{
        anchors.fill: parent
    }

    Rectangle {
        width: 600
        height: 384
        color: "#998f8f"
        border.width: 1
        border.color: "#000000"
        anchors.centerIn: parent

        Rectangle{
            id: recInner
            anchors.fill: parent
            anchors.margins: 5
            color: "#ffffff"
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 8
            anchors.topMargin: 8
            border.width: 4
            border.color: "#000000"

            TextCtl {
                id: txtwarning
                anchors.top: recInner.top
                anchors.topMargin: 20
                anchors.horizontalCenter: recInner.horizontalCenter
                pointSize: 24
                text: "Warning"
            }

            Image{
                id: imgSmallSpot
                anchors.horizontalCenterOffset: 1
                anchors.top: txtwarning.bottom
                anchors.topMargin: 50
                anchors.horizontalCenter: recInner.horizontalCenter

                source: "../images/g2h2/BBL/217_Adaptersmallsqrgold.png"
             }

            TextCtl {
                id: txtMessage
                y: 144
                width: 2
                height: 100
                anchors.top: imgSmallSpot.top
                anchors.topMargin: 70
                anchors.horizontalCenter: recInner.horizontalCenter
                text: "To avoid adverse effects, please use\n correct adapter."
                pointSize: 18
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: 0
            }

            /*!
                    A button that will send an event to the MCU so it can be closed.
                */
            ImageButton{
                id: btnClose
                anchors.top: txtMessage.bottom
                anchors.topMargin: 25
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

}


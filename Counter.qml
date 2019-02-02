import QtQuick 2.0
import "../components"

/*!
    \qmltype Counter
    \inqmlmodule components
    \brief A component that shows a counter value

    A Counter shows the \l value as text to the user, and shows a reset button that sends an event to the MCU.
    There is no range.
*/

Rectangle {
    id: root
    width: 230
    height: 90
    color: "#00000000"
    smooth: true
    radius: 1
    /*!  The value property that gets displayed to the user in the counter element.
    */
    property real value: -1

    property alias fontFamily: counter.font.family
    /*! The eventID to be sent to the MCU.
    */
    property int eventID
    /*! The propertyID to be echoed to the MCU when the value is changed.
    */
    property int propertyID

    onValueChanged: {
        if (value > -1)
        {
            counter.text = value.toFixed(0);
//            echoPropertyToMCU(propertyID, padZeros(value));
        }
    }

    Rectangle {
        id: rec
        x: 5
        y: 32
        width: 130
        height: 55
        color: colorLightGrey
        radius: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3

        /*!
            This Text element will display the value property to the user.
        */
        Text{
            id: counter
            width: 130
            height: 55
            font.bold: true
            font.family: fontFamily
            color: "#000000"
            text: ""
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 35
        }
    }

    TextCtl {
        id: t_counter
        width: 110
        height: 33
        x: 15
        y: 0
        text: "Counter"
        textColor: textTitleColor
        pointSize: 15
    }

    /*
      ImageButton that will send the eventID to the MCU.
      The function sendEventToMCU is in the Screen component.
    */
    ImageButton {
        id: btnReset
        x: 144
        width: 86
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.left: title.right
        anchors.leftMargin: 25
        showAnimation: false
        imageUp: "../images/g2h2/BBLResetButton.png"
        imageDown: "../images/g2h2/BBLResetButton.png"
        onButtonPress: {
            if (screenActiveApp == 1) {
                sendEventToMCU(12, "00012");            // UI_MSG_E_RESETCOUNTER: kickstart the 3 sec timer
            }
        }
        releaseEventId: 157
    }

}

import QtQuick 2.0
import "."
/*!
    \qmltype Repeater
    \inqmlmodule components
    \brief A push button component with a text label.

    The Repeater allows a user to push a mouse area to send an event to the MCU.
    It can be styled using Rectangle element colors and borders. No images are used.
*/

Rectangle {
    id: root
    width: 150
    height: 200
    color: "#00000000"
    radius: 0
    border.width: 0

    /*!
        The number received from the MCU and displayed to the user.
        Set it to min-1 so no number is displayed without it being set.
        Note only a message from the MCU can force the value to be set.
    */
    property real value: min - 1
    /*!
      The allowable decimal positions for the selected number.
    */
    property int precision: 1
    /*!
        The minimum value that can be selected.
    */
    property real min
    /*!
        The maximum value that can be selected.
    */
    property real max
    /*!
        The font family to use for the text label.
    */
    property alias titleFontSize: txtRepeat.pointSize
    property alias titleFontBold: txtRepeat.font_bold
    property alias titleFontColor: txtRepeat.textColor

    property alias fontFamily: txtValue.font.family
    property alias fontSize: txtValue.font.pixelSize
    property alias textActual: txtValue.text

    property alias textBoxYpos: rectRepeatBox.y
    property alias textBoxWidth: rectRepeatBox.width
    property alias textBoxHeight: rectRepeatBox.height
    property alias textBoxColor: rectRepeatBox.color
    property alias textBoxRadius: rectRepeatBox.radius
    /*!
      The event id that gets sent to the MCU.
    */
    property int eventID
    /*!
        The unit of measure to display.
    */
    property string textTitle: "Repeat"
    property string unitMeasure: ""
    /*!
        The property id to echo back to the MCU.
    */
    property int propertyID

    /*!
        Method that gets fired when the value has changed.  When the value changes the text will change and
        the propertyID and value will be echoed back to the MCU.
    */
    onValueChanged: {
        if (value != min - 1) {
            //Set the text to Off if zero
            if (value === 0) {
                txtValue.text = "OFF";
                rectRepeatBox.border.color = colorLightGrey;
            } else {
                txtValue.text = value.toFixed(precision) + unitMeasure
                rectRepeatBox.border.color = "#eeee3a";
            }
//            echoPropertyToMCU(propertyID, padZeros(value));
        }
    }

    /*!
        signals that for mouse events
    */
    signal buttonClick()
    onButtonClick: {
    }

    signal buttonPress()
    onButtonPress: {
    }

    signal buttonRelease()
    onButtonRelease: {
        if (screenActiveApp == 1) {
            screen.startaudio = 1;
            sendEventToMCU(eventID, "00000");
        }
    }
    Rectangle {
        id: rectRepeatBox
        x: 30
        y: 82
        width: 85
        height: 65
        color: colorLightGrey
        radius: 5
        border.width: 5
        border.color: colorLightGrey
        anchors.horizontalCenter: parent.horizontalCenter
        Text{
            id: txtValue
            width: 80
            height: 41
            font.bold: true
            anchors.centerIn: parent
            font.pixelSize: 25
            color: "#000000"
            text: ""
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: 0
            font.family: Style.default_font
        }
        MouseArea{
            id: ma
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: -2
            onClicked: buttonClick()
            onPressed: buttonPress()
            onReleased: buttonRelease()
        }
    }

    TextCtl {
        id: txtRepeat
        x: 10
        width: 128
        height: 37
        text: textTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        visible: timeRepeatVisible
        textColor: textTitleColor
        pointSize: 20
        font_bold: false
    }
}

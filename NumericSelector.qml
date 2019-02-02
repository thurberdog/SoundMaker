import QtQuick 2.0
import "../components"
import "."
/*!
    \qmltype NumericSelector
    \inqmlmodule components
    \brief A two push button component with a text label. Allows a user to push 2 buttons to send events to the MCU.

    The NumericSelector type can be styled using images and text. It is composed of two ImageButtons, a Rectangle and a Text
    element.  It will send an increase and a decrease event to the MCU.
*/

Item{
    id: root
    /*!
        The minimum value that can be displayed.
    */
    property real min
    /*!
        The maximum value that can be displayed.
    */
    property real max
    /*!
        The number received from the MCU and displayed to the user.
        Set it to min-1 so no number is displayed without it being set.
        Note only a message from the MCU can force the value to be set.
    */
    property real value: -1
    /*!
      The allowable decimal positions for the selected number.
    */
    property int precision: 0

    property string txtVal: ""
    /*!
      The unit measure to be displayed.
    */
    property string unitMeasure: ""
    property string textTitle: ""
    /*!
      The increase eventID that gets sent to the MCU.
    */
    property int increaseEvent
    /*!
      The decrease eventID that gets sent to the MCU.
    */
    property int decreaseEvent
    /*!
      The property id that gets echoed back to the MCU when the value has changed.
    */
    property int propertyID
    /*!
       The font family for the text.
    */
    property alias fontFamily: txtValue.font.family
    property alias fontPixelSize: txtValue.font.pixelSize
    property alias textValue: txtValue.text
    /*!
        Property alias to change the btnIncrease up image.
    */
    property alias increaseImageUp: btnIncrease.imageUp
    /*!
        Property alias to change the btnIncrease down image.
    */
    property alias increaseImageDown: btnIncrease.imageDown
    /*!
        Property alias to change the btnDecrease up image.
    */
    property alias decreaseImageUp: btnDecrease.imageUp
    /*!
        Property alias to change the btnDecrease down image.
    */
    property alias decreaseImageDown: btnDecrease.imageDown
    /*!
        Property aliases to set the btnIncrease width and height
    */
    property alias increaseImageWidth: btnIncrease.width
    property alias increaseImageHeight: btnIncrease.height
    /*!
        Property aliases to set the btnDecrease width and height
    */
    property alias decreaseImageWidth: btnDecrease.width
    property alias decreaseImageHeight: btnDecrease.height

    /*!
        Property aliases to set the display rectangle width and height
    */
    property alias rectangleWidth: rec.width
    property alias rectangleHeight: rec.height

    property alias itemHpos: col.x

    property alias txtCtlHorizMargin: txtLabel.txtCtlMargin
    property alias txtTitleHorizMargin: txtTitle.txtCtlMargin

    property int txtTitleXpos: 37
    property int itemColXpos: 0

    onItemHposChanged: {
        col.x = itemHpos;
    }

    property alias itemWidth: root.width
    property alias itenHeight: root.height
    width: 250
    height: 350

    onItemWidthChanged: {
        width = itemWidth;
    }
    onItenHeightChanged: {
        height = itenHeight;
    }

    /*!
        Method that gets fired when the value has changed.  When the value changes the text will change and
        the propertyID and value will be echoed back to the MCU.
    */
    onValueChanged: {
        if (value == -1)
            txtValue.text = "";
        else if (value == 0)
            txtValue.text = "0";
//            txtValue.text = "SHOT";
        else
            txtValue.text = value.toFixed(precision);
//        echoPropertyToMCU(propertyID, padZeros(value));
    }

    /*!
        Column element used for vertical display.
    */
    Column{
        id: col
        x: 116;
        width: 108;
        height: 253
        anchors.top: txtTitle.bottom
        anchors.topMargin: 20
        anchors.horizontalCenterOffset: itemColXpos
        anchors.horizontalCenter: parent.horizontalCenter
        //        spacing: -2
        spacing: 100

        ImageButton{
            id: btnIncrease
            text: ""
            anchors.horizontalCenter: parent.horizontalCenter
            imageUp: "../images/g2h2/Button_up.png"
            imageDown: "../images/g2h2/Button_up.png"
            width: 91
            height: 73
            releaseEventId: 0

            onButtonPress: {
                if (screenActiveApp == 1) {
                    sendEventToMCU(increaseEvent, "00000");
                    startaudio = 1;
                    autoRepeat = true;
                    screen.monostate = 0;        // reset. joule sent badbeep() has set this flag to 1
                    if (autoRepeatCounter == -1) {
                        autoRepeatInterval = 250;
                        autoRepeatCounter = 0;
                    }
                }
            }
            onButtonRelease: {
                startaudio = 0;
                autoRepeatInterval = 0;
                screen.monostate = 0;           // reset. joule sent badbeep() has set this flag to 1
            }
        }

        ImageButton{
            id: btnDecrease
            x: 0
            y: 0
            text: ""
            anchors.horizontalCenter: parent.horizontalCenter
            imageUp: "../images/g2h2/Button_down.png"
            imageDown: "../images/g2h2/Button_down.png"
            width: 91
            height: 73
            releaseEventId: 0

            onButtonPress: {
                if (screenActiveApp == 1) {
                    sendEventToMCU(decreaseEvent, "00000");
                    startaudio = 1;
                    autoRepeat = true;
                    screen.monostate = 0;        // reset. joule sent badbeep() has set this flag to 1
                    if (autoRepeatCounter == -1) {
                        autoRepeatInterval = 250;
                        autoRepeatCounter = 0;
                    }
                }
            }
            onButtonRelease: {
                startaudio = 0;
                autoRepeatInterval = 0;
                screen.monostate = 0;        // reset. joule sent badbeep() has set this flag to 1
            }
        }

    }

    TextCtl {
        id: txtTitle
        anchors.top: parent.top
        anchors.topMargin: 8
        width: 128
        height: 40
        text: textTitle
        textColor: textTitleColor
        font_bold: false
        anchors.horizontalCenter: parent.horizontalCenter
    }
    TextCtl {   // note: special characters are not supported by Helvetica font style
        id: txtLabel
        width: 62
        height: 40
        text: unitMeasure
        anchors.left: txtTitle.right
        anchors.top: parent.top
        anchors.topMargin: 8
        pointSize: 13
        font_bold: false
        fontfamily: "DejaVu Sans"
        textColor: textTitleColor
    }

    /*!
      Rectangle used to display the value to the user.
    */
    Rectangle {
        id: rec
        width: 156
        height: 95
        color: "#00000000"
        radius: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: itemColXpos
        anchors.top: parent.top
        anchors.topMargin: 144
        border.width: 6
        border.color: "#00000000"

        Text {
            id: txtValue
            x: -101
            width: 150
            height: 74
            text: ""
            anchors.horizontalCenter: parent.horizontalCenter
            color: userParamColor
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            font.bold: false
            font.pixelSize: 80
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "HelveticaNeue MediumCond"
        }
    }

    Component.onCompleted: {
    }
}

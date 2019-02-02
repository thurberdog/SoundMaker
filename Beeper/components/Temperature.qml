import QtQuick 2.0
import "."
/*!
    \qmltype Temperature
    \inqmlmodule components
    \brief A two push button component with a text label. Allows a user to push 2 buttons to send events to the MCU.

    The Temperature type can be styled using images and text. It is composed of two ImageButtons, a Rectangle, Text
    element and a thermometer indicator image.  It will send an increase and a decrease event to the MCU.
*/

Item {
    id: item1
    width: 300
    height: 350
    /*!
        The actual temperature.
    */
    property real actualTemperature
    /*!
        The increment in pixels to adjust the height of the thermometer when the actual temperature
        changes
    */

    // Total pixels for thermometer is: imgTemp.height - recSpacer.height - 14 = 150 piexels
    // For a total of 30 degrees, 5 pixels per degree
    property real increment: 1.25
    property real tempMaxHeight: imgTemp.height - recSpacer.height - 14
    property real tempColdZone: 0.17 * tempMaxHeight
    property real tempHotZone: 0.17 * tempMaxHeight
    property real tempNeutralZone: tempMaxHeight - (tempColdZone + tempHotZone)

    /*!
        The number received from the MCU and displayed to the user.
        Set it to min-1 so no number is displayed without it being set.
        Note only a message from the MCU can force the value to be set.
    */
    property real value : -1
    /*!
      The allowable decimal positions for the selected number.
    */
    property int precision: 0
    /*!
        The minimum value that can be displayed.
    */
    property real min
    /*!
        The maximum value that can be displayed.
    */
    property real max
    /*!
      The increase event id that gets sent to the MCU.
    */
    property int decreaseEvent
    /*!
      The decrease event id that gets sent to the MCU.
    */
    property int increaseEvent

    property string unitMeasure:  "\u2103"

    property int silenceCtrl: -1

    /*!
      The property id that gets echoed back to the MCU when the value has changed.
    */
    property int propertyID
    /*!
        The property id that gets echoed back to the MCU when the actual temperature has changed.
    */
    property int actualTemperaturePropertyID
//    property alias fontFamily: txtValue.font.family
    /*!
        Method that gets fired when the value has changed.  When the value changes the text will change and
        the propertyID and value will be echoed back to the MCU.
    */
    onValueChanged: {
        if (value !=  min - 1)
        {
            m_temp.value = value;
//            echoPropertyToMCU(propertyID, padZeros(value));
        }
    }

    property real actualTempPixels: -1
    onActualTemperatureChanged: {
        rectMercuryFill.width = actualTemperature * 2.8;
//        actualTempPixels = actualTemperature / 100 * tempMaxHeight;
//        if (actualTempPixels < tempColdZone) {
//            rectColdZone.height = actualTempPixels;
//            rectNeutralZone.height = 0;
//            rectHotZone.height = 0;
//        } else if (actualTempPixels < (tempColdZone + tempNeutralZone)) {
//            rectColdZone.height = tempColdZone;
//            rectNeutralZone.height = actualTempPixels - tempColdZone;
//            rectHotZone.height = 0;
//        } else {
//            rectColdZone.height = tempColdZone;
//            rectNeutralZone.height = tempNeutralZone;
//            rectHotZone.height = actualTempPixels - (tempColdZone + tempNeutralZone);
//        }
//        echoPropertyToMCU(actualTemperaturePropertyID, padZeros(actualTemperature));
    }

    Image {
        id: imgTemp
        source: "../images/g2h2/BBL/Temp_Indicator.png"
        width: 66
        height: 206
        anchors.left: m_temp.right
        anchors.leftMargin: -85
        anchors.verticalCenterOffset: 17
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: 88

        Rectangle {
            id: recSpacer
            y: 168
            anchors.bottom: parent.bottom
            width: 40
            height: 42
            color: "transparent"
            anchors.horizontalCenterOffset: -11
            anchors.bottomMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            anchors.leftMargin: 2
        }
        Rectangle {
            id: rectMercuryFill
            y: 0
            width: 0
            height: 5
            gradient: Gradient {
                GradientStop {
                    position: 1
                    color: "#6097ff"        // darker color
                }

                GradientStop {
                    position: 0
                    color: "#b7d0ff"
                }
            }
            z: 0
            scale: 1.7
            transformOrigin: Item.Left
            rotation: 270
            //            color: "transparent"
            anchors.bottom: recSpacer.top
            anchors.bottomMargin: -6
            anchors.left: parent.left
            anchors.leftMargin: 27
        }

//        GradientStop {
//            position: 0
//            color: "#6097ff"
//        }

//        GradientStop {
//            position: 1
//            color: "#b7d0ff"
//        }

        //Rectangle that heights get adjusted when the actual temperature changes
        Rectangle {
            id: rectColdZone
            width: 8
            height: 00
            color: "#6699ff"
            anchors.bottom: recSpacer.top
            anchors.bottomMargin: -2
            anchors.left: parent.left
            anchors.leftMargin: 23
        }
        Rectangle {
            id: rectNeutralZone
            width: 8
            height: 0
            color: "#6699ff"
            anchors.bottom: rectColdZone.top
            anchors.bottomMargin: -4
            anchors.left: parent.left
            anchors.leftMargin: 23
        }
        Rectangle {
            id: rectHotZone
            width: 8
            height: 0
            color: "#6699ff"
            anchors.bottom: rectNeutralZone.top
            anchors.bottomMargin: -6
            anchors.left: parent.left
            anchors.leftMargin: 23
        }
    }

    onSilenceCtrlChanged: {
//        echoPropertyToMCU(90, silenceCtrl);
        if (silenceCtrl == 1) {
            startaudio = 0;
        }
    }

    NumericSelector{
        id: m_temp
        y: 0
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        textTitle: "Temperature"
        unitMeasure: "(\u2103)"
        itemColXpos: -45
        txtCtlHorizMargin: 5
        txtTitleHorizMargin: -20
        min: 1
        max: 30
        increaseEvent: 7
        decreaseEvent: 8
        propertyID: 5
        precision: 0
        //        fontPixelSize: 60
    }

//    Rectangle {
//        id: test
//        x: 10
//        y: 279
//        height: 6
//        rotation: 90
//        gradient: Gradient {
//            GradientStop {
//                position: 1
//                color: "#ffffff"        // "#89b2ff"
//            }

//            GradientStop {
//                position: 0
//                color: "#6097ff"        //6097ff
//            }
//        }
//        width: 8
//    }

    Component.onCompleted: {
    }
}

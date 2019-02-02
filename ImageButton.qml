import QtQuick 2.0

import "."
/*!
    \qmltype ImageButton
    \inqmlmodule components
    \brief A push button with a text label

    The ImageButton type provides a button with a text label that can be styled using images.
*/

Item {
    id: root
    property string default_font: "HelveticaNeue MediumCond"
    property string imgPath: "../images/g2h2/"
    property bool   b_BeepEnabled:  true
    property bool   b_FeatureEnabled: false
    property alias  mouseAreaProp : mouseArea

    property int    releaseEventId: -1          // event for the image button
    property int    imageButtonPropertyId: -1   // property ID for the image button

    property int   currScrnActive: 1
    /*!
        The imageUp property is used for the intial state of the button.
    */
    property alias imageUp: border_image1.source
    /*!
        The imageDown property is used for the depressed state of the button.  Signaling to the user
        that the button has been pressed.
    */
    property alias imageDown: border_image2.source
    /*!
        The imageDisabled property is used when the button is disabled.
    */
    property alias imageDisabled: border_image3.source
    property alias imageDisabledOpacity: border_image3.opacity
    /*!
        The text of the label shown within the button.
    */
    property alias text: text.text
    /*!
        The color of the text of the label.
    */
    property alias textColor: text.color
    /*!
        The size of the text.
    */
    property alias textFontPixel: text.font.pixelSize

    /*!
        Determines if the ImageButton is enabled.
    */
    property bool disabled: false
    property int active: -1
     /*!
        If autoRepeat is enabled, then the buttonPress(), buttonRelease(), and buttonClick() signals are
        emitted at regular intervals when the button is down. autoRepeat is off by default.
        The initial delay and the repetition interval are defined in milliseconds by autoRepeatInterval.
    */
    property bool autoRepeat: false
    /*!
        The time in milliseconds of the button's autorepeat interval.
    */
    property int autoRepeatInterval: 200
    property int autoRepeatCounter: -1
    /*!
        Determines if we show an animation.
    */
    property bool showAnimation: false
    /*!
        The font properties of the text of the label.
    */
    property alias font: text.font

    width:  imageWidth
    height: imageHeight

    onActiveChanged: {
        // value of 2 is designed for alternative button ID
        if (active > 0)
            visible = true;
        else if (active <= 0)
            visible = false;
        if (active >= 2)
            disabled = false;
        else if (active < 2)
            disabled = true;
    }

    Audio {
        id: id_audio
    }
    /*!
        signals that for mouse events
    */
    signal buttonEnter()

    //signal buttonClick()
    //onButtonClick: {
    //}

    signal buttonPress()
    onButtonPress: {
        if (autoRepeat == true) {
            autoRepeatTimer.running = true;
            autoRepeatTimer.repeat = true;
        }
    }

    signal buttonRelease()
    onButtonRelease: {
        if (releaseEventId != 0 && screenActiveApp == 1) {
            id_audio.startaudio = 1;
            sendEventToMCU(releaseEventId, "00000");
        }
        resetButton();
    }

    signal buttonExit()
    onButtonExit: {
        resetButton();
    }

    function resetButton() {
        id_audio.startaudio = 0;    //false;
        autoRepeatInterval = 0;
        autoRepeatCounter = -1;
    }


    function repeatButton() {
        startaudio = 1;
        if (autoRepeat == true) {
            autoRepeatTimer.running = true;
            autoRepeatTimer.repeat = true;
        }
    }

    /*!
        Timer element to trigger button signals for auto repeat functionality.
    */
    Timer {
        id: autoRepeatTimer
        triggeredOnStart: false
        interval: autoRepeatInterval
        repeat: true
        running: autoRepeat && mouseArea.pressed

        onTriggered: {
            if (screen.monostate == 1) {
                repeatButton();
            } else {
                if (autoRepeatCounter >= 0) {
                    autoRepeatCounter++;
                    if (autoRepeatCounter == 4) {
                        autoRepeatInterval = 100;
                    } else if (autoRepeatCounter == 8) {
                        autoRepeatInterval = 50;
                    }
                }
                buttonPress();
            }
        }
    }

    /*!
        Image for default state of the button.
    */
    BorderImage {
        id: border_image1
        visible: !( mouseArea.pressed && mouseArea.containsMouse )
        anchors.fill: parent
        opacity: !root.disabled ? 1.0 : 0.25
        asynchronous: true
    }

    /*!
        Image for pressed state of the button.
    */
    BorderImage {
        id: border_image2
        visible: ( mouseArea.pressed && mouseArea.containsMouse )
        anchors.fill: parent
        opacity: !root.disabled ? 0.6 : 0.25
        asynchronous: true
    }

    /*!
        Image for disabled state of the button.
    */
    BorderImage {
        id: border_image3
        visible: root.disabled
        anchors.fill: parent
        asynchronous: true
    }

    /*!
        MouseArea element that emits signals.
    */
    MouseArea {
        id: mouseArea
        anchors.fill: parent
//        onClicked: buttonClick()
        onPressed: buttonPress()
        onReleased: buttonRelease()
        onExited: buttonExit()
        onEntered: buttonEnter()
        enabled: !root.disabled
    }

    /*!
        Text element for the button.
    */
    Text {
        id: text
        text: qsTr("")
        z: 0
        color: qsTr("Black")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        font.family: default_font
    }
}

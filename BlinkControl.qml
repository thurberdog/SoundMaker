import QtQuick 2.0

/*!
    \qmltype BlinkControl
    \inqmlmodule components
    \brief A blink control component to be displayed.
*/

Item{
    id: root
    width: 200
    height: 200

    property alias blink: blinkAnimation.running
    property alias img_width:  img_Animate.width
    property alias img_height: img_Animate.height
    property alias source:     img_Animate.source
    property int volume: 65 // this will be changed by the app volume control

    onBlinkChanged: {
        if (blink) {
            blinkAnimation.running = true;
        }
        img_Animate.source = source;
    }
    /*
    Image {
        id: img_Animate
        source: source;
        SequentialAnimation {
            id: blinkAnimation
            running: false  // initial state
            loops: Animation.Infinite

            PropertyAnimation {
                target: img_Animate
                properties: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
            PropertyAnimation {
                target: img_Animate
                properties: "scale"
                from: 1.0
                to: 0.1
                duration: 200
            }
        }
    }
    */
    Image {
        id: img_Animate
    }

    Timer {
        id: blinkAnimation
        triggeredOnStart: false
        interval: 500
        repeat: true
        running: false
        property int toggle: 1
        onTriggered: {
            toggle = ~toggle;
            if ((toggle & 1) == 0)
                img_Animate.visible = false;
            else
                img_Animate.visible = true;
        }
    }
}

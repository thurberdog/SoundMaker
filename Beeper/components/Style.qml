pragma Singleton
import QtQuick 2.0
import QtMultimedia 5.0

QtObject {
    property color mainbg: "#808080"
    property int screen_width: 1024
    property int screen_height: 768
    property string screen_bg_image: "images/flat/background/background1024_mermaid.png"
    property string audio_source: "../sounds/button.wav"
    property int    loudness: 85
    property int    audioPlay: 0
    property bool ctrlReleased: false
    // TTF font file: HelveticaNeueMedium.ttf   family name: "Helvetica Neue"
    // TTF font file: HELN.TTF   family name: "HELN.TTF"

//    property string default_font:  "Helvetica Neue"   //   //"HelvLight"
    property string default_font: "HelveticaNeue MediumCond"
}

import QtQuick 2.0
import "."
/*!
    \qmltype TextCtl
    \define common properties
*/

Item{
    id: root
    property string default_font: "HelveticaNeue MediumCond"
    property alias pid: id_text.property_id
    property alias text:      id_text.text
    property alias textColor: id_text.color
    property alias font_bold: id_text.font.bold
    property alias pointSize: id_text.font.pointSize
    property alias wrapMode:  id_text.wrapMode
    property alias horAlign:  id_text.horizontalAlignment
    property alias verAlign:  id_text.verticalAlignment
    property alias fontfamily:  id_text.font.family

    property int txtCtlMargin: 0

    Text {
        id: id_text
        z: 1
        text: ""
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: txtCtlMargin
        anchors.horizontalCenter: parent.horizontalCenter

        color: userParamColor
        font.bold: false
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: default_font
        font.pointSize: 20
        wrapMode: Text.WordWrap

        property int property_id: -1
        onTextChanged: {
//            if (property_id > -1)
//                echoPropertyToMCU(property_id, text);
        }

    }
}

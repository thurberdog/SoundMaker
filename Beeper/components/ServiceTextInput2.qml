import QtQuick 2.0

/*!
    \qmltype ScannerSizeSelector
    \inqmlmodule components
    \brief A component for submenu screen controls. It uses VerticalSelectGroup element to create
           A group of Switch buttons in a vertical style.  It allows a user to select a Scanner Size.

*/


Rectangle {

    property alias rootWidth: root.width
    property alias inputLabel: t_inputLabel.text
    property alias inputData: b_inputData.text
    property alias labelWidth: t_inputLabel.width
    property alias labelHeight: t_inputLabel.height
    property alias labelColor: t_inputLabel.color
    property alias labelBold: t_inputLabel.font.bold
    property alias dataWidth: b_inputData.width
    property alias dataHeight: b_inputData.height
    property alias labelFont: t_inputLabel.font.pixelSize
    property alias dataFont: b_inputData.font.pixelSize
    property alias dataColor: b_inputData.color
    property alias dataBold: b_inputData.font.bold
    property alias dataHAlign: b_inputData.horizontalAlignment

    property int srvcInput2PropertyId: 1501
    property real srvcInput2Status: -1

    property int precision: 1

    onSrvcInput2StatusChanged: {
       if (srvcInput2Status >= 0) {
            inputData = srvcInput2Status.toFixed(precision);
//            echoPropertyToMCU(srvcInput2PropertyId, padZeros(srvcInput2Status))
       }
    }

    id: root
    x:0
    width: 140
    height: 50
    color: "transparent"
    Text {
        id: t_inputLabel
        y: 2
        width: 50
        height: 24
        text: qsTr("")
        wrapMode: Text.WordWrap
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.left: parent.left
        anchors.leftMargin: 2
        font.pixelSize: 15
        font.family: "HelveticaNeue MediumCond"
    }
    Text{
        id: b_inputData
        x: 2
        y: 2
        width: 84
        height: 46
        text: qsTr("")
        font.pixelSize: 24
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: t_inputLabel.right
        anchors.leftMargin: 1
        font.family: "HelveticaNeue MediumCond"
    }
}

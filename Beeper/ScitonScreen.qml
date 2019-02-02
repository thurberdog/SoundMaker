import QtQuick 2.0
import "components"
import "."
/*!
    ScitonScreen.qml Screen
*/

Screen{
    id: screen
    objectName: "screen"
    screenID: 400
    layerVisible: false
    standByButtonVisible: false
    applyButtonVisible: false
    btnPrevious_Enable: false

    property string setting
    property alias password_INQUIRY: codeEntry.upload  // p888

    property alias startupTimeRemain: t_timeRemainMain.srvcInput2Status

    onStartupTimeRemainChanged: {
        if (startupTimeRemain > 0)
            t_timeRemainMain.visible = true;
        else
            t_timeRemainMain.visible = false;
    }

    CodeEntry {
        id: codeEntry
        x: 390; y:190
        width: 245;         height: 406
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter

        property int code: 0
        property int upload: -1
        onUploadChanged: {
            sendEventToMCU(888, codeEntry.accumulator);   // send password in text format
            upload = -1;
        }
        onAccumulatorChanged: {
            sendEventToMCU(888, codeEntry.accumulator);   // send password in text format
            var setting = usersetting();
            sendEventToMCU(888, setting);
        }
    }

    function usersetting() {
//        ack = settings.getValue("user");
    }

    property int clicksCnt: 0
    MouseArea {
        id: mouseClick_JouleLogo
        x: 426
        y: 37
        width: 172
        height: 129
        onReleased: { // don't beep because it's not for user
            clicksCnt++;        // try to keep the controller parser less busy ...
            if (clicksCnt < 7)  // ... its handler might not be quick enough for so many same events
                sendEventToMCU(201, "00201");
            //else if (clicksCnt >= 4)
            //    clicksCnt = 0;
        }
    }


    ServiceTextInput2{
        id: t_timeRemainMain
        x: 269
        width: 380
        rootWidth: 380
        height: 32
        anchors.top: codeEntry.bottom
        anchors.topMargin: 35
        anchors.horizontalCenter: parent.horizontalCenter
        labelBold: false
        dataFont: 16
        dataWidth: 30
        dataHeight: height
        labelWidth: 350
        labelHeight: height
        labelFont: 20
        inputLabel: qsTr("Performing safety checks (secs left): ")
        inputData: qsTr("")
        precision: 0
        srvcInput2Status: 204
        visible: false
    }

    Component.onCompleted: {
    }
}


import QtQuick 2.0
import "."
import "../components"
/*!
    \qmltype ErrorDialogBox
    \brief A message to be displayed when screen id = 237. called from LoadErrorScreen()
    \ the screen will be active upon:
    \       onShowErrorDialogMenuChanged() by property bool showErrorDialogMenu=true
    The dialogbox type can be styled using text and Rectangle properties.
*/

Rectangle{
//    property alias errorIdVal: t_errIdNum.srvcInput2Status
//    property alias errorDescr: t_errIdDescr.srvcInputString

    /*!
        An event id to send to MCU to close the warning message.
    */
    property string default_font: "HelveticaNeue MediumCond"
    property int eventID
    property string message     // responds to p103

    property int btnClearError: -1

    onBtnClearErrorChanged: {
        if (btnClearError == 1) {
            btnClose.disabled = true;
            btnClose.visible = false;
        } else {
            btnClose.disabled = false;
            btnClose.visible = true;
        }
    }

    id: root
    width: 1024
    height: 768
    color: "transparent"
    border.width: 0
    
    /*!
        peudo MouseArea used to prevent a user from clicking any other buttons on the parent screen.
    */
    Rectangle {
        id: rectangle1
        width: 1024
        height: 640
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        border.width: 0
        opacity: 0.6
        MouseArea{
            x: 0
            y: 0
            width: 1024
            height: 650
        }
    }
    /*!
        signal to hook into to close the warning screen
    */
    signal close();
    onClose: {
        if (typeof(connection) == 'undefined')
            // LinuxVM
            beeper.openwave("/home/reach/VMShare/qmlscene/button.wav");  // default audio for button press
        else
            beeper.openwave("/application/src/sounds/button.wav");    // restore the default one
    }

    onMessageChanged:
    {
        if ((message === "CLEAR ALL") || (message === "CLEAR")) {
            innerRec.new_system_message = "CLEAR ALL";
            m_systemMessage.model.clear();
        }
        else {
            innerRec.new_system_message = " " + message;
        }
    }

    Rectangle {
        id: outerRect
        x: 254
        y: 231
        width: 600
        height: 400
        color: bannerColor
        radius: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 3
        border.color: bannerColor

        Rectangle {
            id:innerRec
            color: bannerColor
            radius: 2
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent

            property string new_system_message;
            width: 550
            height: 350

            Component.onCompleted:
            {
                m_systemMessage.model.clear();
            }

            Component {
                id: component_delegate
                Item {
                    width: parent.width; height: 25
                    Column {
                        Text { text: message
                               font.pointSize: 14
                               font.family: default_font
                               color: "#ffffff"
                        }

                    }
                    MouseArea {
                        id: mouse_area1
                        z: 1
                        hoverEnabled: false
                        anchors.fill: parent

                        onClicked:{
                            m_systemMessage.currentIndex = index;
                        }
                    }
                }
            }

            onNew_system_messageChanged: {
                if( (new_system_message === "CLEAR ALL") || (new_system_message === "CLEAR") )
                {
                    m_systemMessage.model.clear();
                }
                else
                {
                    m_systemMessage.model.append({message:new_system_message})
                    m_systemMessage.currentIndex = m_systemMessage.count -1;
                    if(m_systemMessage.model.get(m_systemMessage.currentIndex).message === null)
                    {
                        m_systemMessage.model.remove(currentIndex,1);
                        m_systemMessage.currentIndex = m_systemMessage.count -1;
                    }
//                    echoPropertyToMCU(103, new_system_message)
                }
            }

            ListView {
                id:m_systemMessage
                x: 5
                y: 5
                height: 250
                anchors.rightMargin: 0
                anchors.bottomMargin: 8
                clip: true
                contentHeight: parent.height
                anchors.leftMargin:0
                anchors.topMargin:8
                anchors.fill: parent
                model: SystemMessageModel {}
                delegate: component_delegate
                focus: true
            }

            ImageButton{
                id: btnClose
                y: -18
                width: 45
                height: 45
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""
                anchors.horizontalCenterOffset: 268
                anchors.bottomMargin: 323
                imageUp: "../images/Halo/Exit_pushed_NumPad.png"
                imageDown: "../images/Halo/Exit_pushed_NumPad.png"
                releaseEventId: 117
                disabled: true
                visible: false

                onButtonRelease: {
//                    sendEventToMCU(releaseEventId, "00117");
                    if (typeof(connection) == 'undefined')
                        // LinuxVM
                        beeper.openwave("/home/reach/VMShare/qmlscene/button.wav");  // default audio for button press
                    else
                        beeper.openwave("/application/src/sounds/button.wav");    // restore the default one
                }
            }

            TextCtl {
                id: t_info
                x: 215
                y: 325
                width: 120
                height: 25
                pointSize: 8
                text: "Swipe up & down"
                font_bold: false
                textColor: "#ffffff"
            }
        }
    }

    Component.onCompleted: {
    }
    Component.onDestruction: {
        if (typeof(connection) == 'undefined')
            // LinuxVM
            beeper.openwave("/home/reach/VMShare/qmlscene/button.wav");  // default audio for button press
        else
            beeper.openwave("/application/src/sounds/button.wav");    // restore the default one
    }
}

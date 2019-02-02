import QtQuick 2.3
import "../components"
import "."
/*!
    \qmltype Screen
    \inqmlmodule components
    \brief This is used as the base element of individual screens.

    The Screen element handles all the basic gui elements for an individual screen.
    It sends the events and echos properties to the MCU, it also sends messages to the Loader element
    in the maniview.qml file to trigger screen changes when the screenID property is changed.
*/

Rectangle {
//    property string backgroundColor: "#bfbfbf"
//    property string rectTextColor: "#bfbfbf"
//    property string backgroundColor: "#d9d9d6"
//    property string rectTextColor: "#f8f8f8"
    property string default_font: "HelveticaNeue MediumCond"
    property string colorLightBlue1: "#f4fdfd"
    property string colorLightBlue2: "#cfebf8"
    property string colorLightGrey: "#e6e6e6"
    property string colorMedGrey: "#7e7e7e"
    property string colorDarkGrey: "#3a3a3a"
    property string backgroundColor2: "#a7a8aa"
    property string rectTextColor: "#d9d9d6"
    property string bannerColor: "#546fab"
    property string textHeadingColor: "white"
//    property string textTitleColor: colorLightGrey       // labels
//    property string textHeadingColor: "#2f4577"
    property string textTitleColor: "#202020"       // labels

    property int spacingLargeIcons: 40
    property int spacingMediumIcons: 30
    property int spacingSmallIcons: 20
    property int textHeadingPointSize: 23

    property bool bottomLayerVisible: false

    property int screenBuildTimer: 500         // default is 0.5 second before events will be sent
    id: root
    objectName: "AppScreen"
    border.width: 0
    width: 1024
    height: 768
    Image {
        id: mainbckgrnd
        x: 0
        y: 0
        source: "../images/g2h2/mainGeometricBack.png"
    }
    Image {
        id: bottomlayer
        x: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        source: "../images/g2h2/BBLbottomBanner.png"
        visible: bottomLayerVisible
    }

    //    color: backgroundColor

//    gradient: Gradient {
//        GradientStop {
//            position: 0.0
//            color: "#7a8ebe"
//        }
//        GradientStop {
//            position: 1.0
//            color: "#3d507c"
//        }
//    }

//    gradient: Gradient {          // linda favorite colors
//        GradientStop {
//            position: 0.0
//            color: "#dee3ef"
//        }
//        GradientStop {
//            position: 1.0
//            color: "#546fab"
//        }
//    }

    /*!
        The screen id sent from the MCU.
    */
    property int screenID

    property int screenAppSvc: 0
    property real bblPresetsOpacity: 0.3
    property real disableIconOpacity: 0.5
    /*!
        Sets the background image of the screen.
    */
    property string currentScreen: ""

    property int screenActiveApp: 0
/*
    onScreenActiveAppChanged: {
        echoPropertyToMCU(97, screenActiveApp);
    }
*/
    property string bblImgPath: "images/g2h2/BBL/"
    property string bblImgPathComp: "../images/g2h2/BBL/"

    property alias bgImage : background.source      // Sciton Logo
    /*!
        Sets the font family of the text.
    */
    property string fontFamily: default_font
    /*!
      generic visible control for one or more control button
    */
    property real ctrl_Visible: -1

    property alias spkVolume: id_Audio.piezovolume  //p95

    /*!
        Determines if we show a a layer image used on most screens, but not on menus.
    */
    property alias layerVisible: layer.visible
    property int layerHeight: 683
    /*!
        Text to populate the layerTitle Text element.
    */
    property alias subTitle: layerTitle.text
    onSubTitleChanged: {
//        echoPropertyToMCU(41, subTitle);
    }
    property alias new_system_message: txt_SystMsg.text    //p42

    property alias screen_no_debug: scrnNoDebug.text
    property alias generic160: requestScrnId.val
    property alias generic161: scrnId.text
    property alias generic162: scrnEvtMissed.text

    property int imageLrgHeight: 200
    property int imageLrgWidth: 212

    property int imageMedHeight: 161
    property int imageMedWidth: 167

    property int imageHeight: imageLrgHeight
    property int imageWidth: imageLrgWidth

    property int safeParamColor: -1
    property string userParamColor: "colorDarkGrey"

    onSafeParamColorChanged: {
        if (safeParamColor == 1)
            userParamColor = "#ed1c24";      // Red
        else
            userParamColor = "#000000";      // Black
    }

    /*!
        Text to populate the layerWarning Text element.
        The warning in User mode in the banner area.
    */
    property alias subWarning: layerWarning.text
    onSubWarningChanged: {
//        echoPropertyToMCU(94, subTitle);
    }

    /*!
        Text to display as a screen title.
    */
    property alias title: screenTitle.text
    property alias title_txtsize:   screenTitle.font.pixelSize

    /*
        This control is normally located inside the black bar of the layer screen
        The content is usually like 'System Not Ready', 'Foot Switch Depressed', etc...
    */
    TextCtl {
        id: txt_SystMsg     // in response to p42
        z: 1
        x: 500
        y: 88
        width: 470
        height: 32
        textColor: "orange"  //"#e4fe46"    // bright yellow text
        pointSize: 16

        onTextChanged: {
//            echoPropertyToMCU(42, "txt_SystMsg");
        }
    }

    TextCtl {
        id: scrnNoDebug
        z: 1
        x: 800
        y: 15
        width: 150
        height: 20
        textColor: "#ef1010"
        pointSize: 15
        onTextChanged: {
//            echoPropertyToMCU(109, "");
        }
    }

    TextCtl {
        id: scrnId
        z: 1
        x: 820
        y: 45
        width: 130
        height: 20
        textColor: "#ef1010"
        pointSize: 15
        onTextChanged: {
            echoPropertyToMCU(161, "");
        }
    }

    TextCtl {
        id: scrnEvtMissed
        z: 1
        x: 820
        y: 65
        width: 130
        height: 20
        textColor: "#000000"
        pointSize: 15
    }

    Item {
        id: requestScrnId
        z: 1
        x: 620
        y: 15
        width: 130
        height: 20
        property int val: 0
        onValChanged: {
            echoPropertyToMCU(160, screen.screenID);
        }
    }

    property string handpiece: ""

    onHandpieceChanged: {
        if ((layer.visible == true) && (txt_TRLhandpiece != "")) {
            id_txtHandPiece.text = handpiece;
        }
//        echoPropertyToMCU(67, txt_TRLhandpiece);
    }

    property alias subTxt: txt_Limits.text
    onSubTxtChanged: {
        txt_Limits.text = subTxt;
//        echoPropertyToMCU(87, subTxt);
    }

    property int monostate: -1
    property int warningSoundCtrl: -1

    /*!
        The layer image source.
    */
    property alias layerImage: layer
    /*!
        Determines if we show the StandBy, Repeat  or Treat image
    */
    property int standbyMode
    /*!
        Determines if we show the StandBy image on the screen.
    */
    property alias standByButtonVisible: btnStandby.visible
    /*!
        Determines if we show the Apply Settings button on the screen.
    */
    property alias applyButtonVisible: btnApplySettings.visible
    /*!
        Determines if we need to display the Warning element.
    */
    property bool showAdapterWarning       // S222
    onShowAdapterWarningChanged: {
        adapter1Reminder.visible = showAdapterWarning;
        errorDialogMenu.visible = false;

        if (showAdapterWarning)
        {
            echoScreenToMCU(222, "00000");
            nextScreen =  "Adapter1Reminder"  //"warning";
        }
    }

    property int generic_Val3: -1
    onGeneric_Val3Changed: {
        adapter1Reminder.adapterID = generic_Val3;
//        echoPropertyToMCU(93, generic_Val3);
    }

    Adapter1Reminder {
        id: adapter1Reminder
        adapterID: -1
        objectName: "adapter1Reminder"
        anchors.centerIn: parent
        visible: false
        eventID: 117
        z: 100
        onClose:{
        }
    }

    /*!
        Determines if we need to display the ErrorDialogBox element.
    */
    property bool showErrorDialogMenu: false
    onShowErrorDialogMenuChanged: {
        errorDialogMenu.visible = showErrorDialogMenu;
        warning.visible = false;
        if (showErrorDialogMenu)    // s237
        {
            btnPrevious_Flag = false;
            echoScreenToMCU(237, "00000");
            nextScreen = "errorDialogMenu";
        }
        else
        {
            echoScreenToMCU(screenID, "00000");
            if (currentScreen != "HaloApp")
            {
                btnPrevious_Flag = btnPrevious_Enable;
            }
        }
    }

    property alias startaudio: id_Audio.startaudio
    Audio {
        id: id_Audio
    }
    property alias    audiophile: id_Audio.audiophile

    property int clicksCnt: 0
    MouseArea {
        id: mouseClick_JouleLogo
        x: 426
        y: 11
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

    property int blinkerLoudness: 65
    onBlinkerLoudnessChanged: {
        id_blinky.volume = blinkerLoudness;
    }

    Timer {
        id: id_treatmentbeep
            interval: 600; running: false; repeat: true
            onTriggered: {
                beeper.play();
            }
    }

    property int    imgEnable: -1    // receive a value from a screen subclass
    property string imgSource89: "../images/LaserSymbol_91_82px.png";
    BlinkControl {
        id: id_blinky
        x: 710
        y: 677
        width: 80
        height: 80
        source: ""
        blink: false
    }
    onImgEnableChanged: {
        if (imgEnable > 0) {
            id_blinky.source = imgSource89;
            id_blinky.blink = true;
            id_treatmentbeep.running = true;
//            beeper.openwave("/application/src/sounds/treatmentbeep.wav");
//            beeper.play();
        }
        else {
            id_blinky.source = "";
            id_blinky.blink = false;
            id_treatmentbeep.running = false;
//            beeper.openwave("/application/src/sounds/button.wav");    // restore the default one
//            beeper.play();       // uncomment this line if sound is needed
        }
//        echoPropertyToMCU(89, imgEnable);
    }

    /*!
        String of a filename that we get from the the tio-agent when we need to change the screen.
        See the translate.txt file
    */
    property string nextScreen

    onNextScreenChanged: {
        //The Screen elements parent is the loader element in mainview.qml
        if (nextScreen.indexOf('.qml') != -1)
        {
             parent.source = "../" + nextScreen;
            //make sure the warning screen is closed
            showAdapterWarning = false;
            //make sure the error menu screen is closed.
            showErrorDialogMenu = false;
            /////////////////////////////btnPrevious_Enable = true;
        }
    }

    /*!
        This function sends an event to the MCU.
    */
// NON-RELEASE
    property int abcde: 1;

    function sendEventToMCU(eventID, eventValue) {
        if (typeof connection == 'undefined') {
//            console.log(qsTr("e%1=%2\r").arg(eventID).arg(eventValue));
            txtEmulatorEcho.text = qsTr("e%1=%2").arg(eventID).arg(eventValue);
//            abcde = 1;
        } else {
            connection.sendMessage(qsTr("e%1=%2").arg(eventID).arg(eventValue));
        }
    }
    function sendToMCU(eventID, eventValue) {
        if (typeof connection == 'undefined') {
//            console.log(qsTr("e%1=%2\r").arg(eventID).arg(eventValue));
            txtEmulatorEcho.text = qsTr("e%1=%2").arg(eventID).arg(eventValue);
//            abcde = 1;
        } else {
            connection.sendMessage(qsTr("e%1=%2").arg(eventID).arg(eventValue));
        }
    }
    /*!
        This function echos a property to the MCU.
    */
    function echoPropertyToMCU(propertyID, propertyValue)
    {
        if (typeof connection == 'undefined') {
//            console.log(qsTr("p%1=%2\r").arg(propertyID).arg(propertyValue));
            txtEmulatorEcho.text = qsTr("p%1=%2").arg(propertyID).arg(propertyValue);
//            abcde = 1;
        } else {
            connection.sendMessage(qsTr("p%1=%2").arg(propertyID).arg(propertyValue));
        }
    }

    /*!
        This function pads zeros to an integer or float
    */
    function padZeros(val)
    {
        var txt = val.toString();
        while(txt.length < 5)
            txt = "0" + txt;
        return txt;
    }

    /*!
        When the standBy property is changed via a message by the MCU this event will be fired
        and the standby image will be changed.  The property will then be echoed back to the MCU.
    */
    onStandbyModeChanged: {
        if (standbyMode === 0)
        {
            btnStandby.imageDown = "../images/g2h2/JouleStandbyButton.png"
            btnStandby.imageUp = "../images/g2h2/JouleStandbyButton.png"
        }
        else if (standbyMode === 1)
        {
            btnStandby.imageDown = "../images/g2h2/131_btnReady.png"
            btnStandby.imageUp = "../images/g2h2/131_btnReady.png"
        }
        else if (standbyMode === 2)
        {
            btnStandby.imageDown = "../images/g2h2/JouleTreatButton.png"
            btnStandby.imageUp = "../images/g2h2/JouleTreatButton.png"
        }
        else if (standbyMode === 3)
        {   // red 'READY' symbol
            btnStandby.imageDown = "../images/g2h2/131_btnReadyRed.png"
            btnStandby.imageUp = "../images/g2h2/131_btnReadyRed.png"
        }
        else if (standbyMode === 4)
        {   // 'POST' symbol
            btnStandby.imageDown = "../images/g2h2/JoulePostButton.png"
            btnStandby.imageUp = "../images/g2h2/JoulePostButton.png"
        }
        else {
        }

        echoPropertyToMCU(10, padZeros(standbyMode));
    }

    Image {
        id: background
        anchors.horizontalCenterOffset: 1
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../images/g2h2/001_jouleLogo.png"
    }

    Rectangle {
        id: layer
        x: 0
        width: 1024
//        height: layerHeight
        height: 85
        color: "#00000000"
        anchors.top: parent.top
//        anchors.topMargin: root.height - layer.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 0
        Image {
            id: toplayer
            x: 0
            y: 0
            source: "../images/g2h2/BBLtopBanner.png"
        }

        Rectangle {
            id: banner
            width: 1024
            height: 85
            x: 0
//            color: bannerColor
            color: "transparent"
            anchors.top: parent.top
            anchors.topMargin: 0

            Text{
                id: layerTitle
                y: 47
                width: 200
                height: 35
                anchors.left: parent.left
                anchors.leftMargin: 50
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.family: default_font
                font.pixelSize: 24
                text: ""
                anchors.verticalCenterOffset: 17
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: id_txtHandPiece
                y: 45
                width: 370
                height: 35
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                text: ""
                anchors.verticalCenterOffset: 17
                font.bold: true
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: default_font
                font.pointSize: 16
            }

            Text{
                id: layerWarning
                x: 574
                y: 45
                width: 300
                height: 35
                anchors.right: parent.right
                anchors.rightMargin: 150
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ecf371"
                font.family: default_font
                font.pixelSize: 24
                text: ""
                anchors.verticalCenterOffset: 17
            }

            Text {
                id: txt_Limits
                x: 574
                y: 45
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
                anchors.rightMargin: 124
                anchors.verticalCenter: parent.verticalCenter
                width: 326
                height: 35
                color: "#faa905"
                text: qsTr("")
                anchors.verticalCenterOffset: 17
                visible: true
                font.pixelSize: 24
            }
        }


    }

    Text{
        id: screenTitle
        y: 35
        width: 283
        height: 35
        anchors.left: root.left
        anchors.leftMargin: 50
        anchors.top: root.top
        anchors.topMargin: 8
        color: textHeadingColor
        text: ""
        font.family: default_font
        font.pixelSize: 25
        font.bold: true
    }

    ImageButton{
        id: btnStandby
        y: 675
        objectName: "btnStandby"
        anchors.bottom: root.bottom
        anchors.bottomMargin: 27
        anchors.horizontalCenter: root.horizontalCenter
        width: 225
        height: 73
        autoRepeatInterval: 0
        autoRepeat: false
        text: ""
        anchors.horizontalCenterOffset: 0
        imageDown: "../images/g2h2/JouleStandbyButton.png"
        imageUp: "../images/g2h2/JouleStandbyButton.png"
        releaseEventId: 1
    }

    ImageButton{
        id: btnApplySettings
        objectName: "btnApplySettings"
        anchors.bottom: root.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: root.horizontalCenter
        width: 236
        height: 83
        visible: false
        autoRepeatInterval: 0
        autoRepeat: false
        text: ""
        imageDown: "../images/g2h2/445_btnApply.png"
        imageUp: "../images/g2h2/445_btnApply.png"
        releaseEventId: 72
    }

    /*!
        This element is used to create a warning screen.
    */
    Warning{
        id: warning
        objectName: "warning"
        anchors.centerIn: parent
        visible: false
        eventID: 117
        z: 100

        onClose:{
        }
    }

    property bool    btnPrevious_Enable: false
    property bool    btnPrevious_Flag: btnPrevious_Enable

    ImageButton{
        id: btnPrevious
        x: 31
        y: 687
        imageUp: "../images/g2h2/099_Back.png"
        imageDown: "../images/g2h2/099_Back.png"
        width: 90
        height: 60
        z: 1
        visible: btnPrevious_Flag
        autoRepeatInterval: 0
        autoRepeat: false
        releaseEventId: 2
    }

    ErrorDialogBox {
        id: errorDialogMenu
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0
        objectName: "errorDialogMenu"
        anchors.centerIn: parent
        visible: false
        eventID: 300
        z: 100

        onClose:{
            errorDialogMenu.message = "CLEAR ALL";
            errorDialogMenu.destroy();
        }
    }

    /********************** Controls for Windows Emulation ***********************/

    /*!
        Property used by mainview.qml to echo the screen to the txtEmulatorEcho element.
    */
    property alias textEmulatorEcho: txtEmulatorEcho.text
    property alias rowEmulator: rowEmulator

    Row {
        id: rowEmulator
        spacing: 1
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        z: 2
        Rectangle{
            id: recEmulator
            width: 180
            height: 30
            color: "#ffffff"
            border.color: "#000000"
            border.width: 1
            onVisibleChanged: {
                if (visible)
                    txtEmulator.focus = true;
            }

            TextInput {
                id: txtEmulator
                font.family: screen.fontFamily
                font.pixelSize: 16
                anchors.fill: parent
                cursorVisible: true
                anchors.margins: 4

                onCursorVisibleChanged: {
                    if (!cursorVisible)
                        cursorVisible = true;
                }

                Keys.onReturnPressed: {
                    sendMessageToScreen(txtEmulator.text);
                }

                Keys.onSpacePressed: {
                    screen.focus=true;
                    rowEmulator.visible = false;
                }
            }
        }

        ImageButton{
            id: btnEmulator
            width: 73
            height: 30
            font.family: screen.fontFamily
            font.pixelSize: 13
            text: "Send"
            imageDown: "../images/internal_button_dn.bmp"
            imageUp: "../images/internal_button_up.bmp"
            releaseEventId: 0
            onButtonRelease: {
                sendMessageToScreen(txtEmulator.text);
            }
        }

        Rectangle{
            id: recEmulatorEcho
            width: 180
            height: 30
            color: "#ffffff"
            border.color: "#000000"
            border.width: 1

            TextInput {
                id: txtEmulatorEcho
                font.family: screen.fontFamily
                font.pixelSize: 16
                anchors.fill: parent
                anchors.margins: 4
            }
        }
    }
    /*!
        This function emulates messages received by MCU in Windows.
    */
    function sendMessageToScreen(text)
    {
        var values = text.split('=');
        //var screenProperty = "";
        if (values.length === 2 )
        {
            values[0] = values[0].toLowerCase();    // be more friednly :)

            if (values[0].charAt(0) === 's')
            {               
               var scrn = values[0].substring(1,4);
                switch (scrn)
                {
                    case "200":
                        screen.nextScreen = "bblTopMenu.qml";
                        break;
                    case "201":
                         screen.nextScreen = "bblPigmentedLesionsSubMenu.qml";
                        break;
                    case "202":
                        screen.nextScreen = "bblVascularMenu.qml";
                        break;
                    case "203":
                        screen.nextScreen = "bblVasularRosaceaSubMenu.qml";
                        break;
                    case "204":
                        screen.nextScreen = "bblVascularBodySubMenu.qml";
                        break;
                    case "205":
                        screen.nextScreen = "bblHairRemovalMenu.qml";
                        break;
                    case "206":
                        screen.nextScreen = "bblForeverBareSubMenu.qml";
                        break;
                    case "207":
                        screen.nextScreen = "bblHairStaticSubMenu.qml";
                        break;
                    case "208":
                        screen.nextScreen = "bblSkinTyteMenu.qml";
                        break;
                    case "209":
                        screen.nextScreen = "bblAcneUI.qml";
                        break;
                    case "210":
                        screen.nextScreen = "bblVascularFacialBruiseUI.qml";
                        break;
                    case "211":
                        screen.nextScreen = "bblVascularCherryAngiomaUI.qml";
                        break;
                    case "212":
                        screen.nextScreen = "bblVascularBodyUI.qml";
                        break;
                    case "213":
                        screen.nextScreen = "bblVascularRosaceaUI.qml";
                        break;
                    case "214":
                        screen.nextScreen = "bblVascularFacialVesselsUI.qml";
                        break;
                    case "215":
                        screen.nextScreen = "bblPigmentedLesionsUI.qml";
                        break;
                    case "216":
                        screen.nextScreen = "bblForeverBareUI.qml";
                        break;
                    case "217":
                        screen.nextScreen = "bblHairRemovalStaticUI.qml";
                        break;
                    case "218":
                        screen.nextScreen = "bblSkinTyteMotionUI.qml";
                        break;
                    case "219":
                        screen.nextScreen = "bblSkinTyteStaticUI.qml";
                        break;
                    case "220":
                        screen.nextScreen = "bblBroadBandLightUI.qml";
                        break;
                    case "222":
                        screen.showAdapterWarning = true;
                        break;
                    case "223":
                        screen.nextScreen = "bblSystemMessages.qml";
                        break;
                    case "224":
                        screen.nextScreen = "bblManualMode.qml";
                        break;
                    case "225":
                        screen.nextScreen = "jouleTopMenu.qml";
                        break;
                    case "226":
                        screen.nextScreen = "jouleArmMenu.qml";
                        break;
                    case "227":
                        screen.nextScreen = "jouleArmApp2940Menu.qml";
                        break;
                    case "228":
                        screen.nextScreen = "Resurfacing_Scanner.qml";
                        break;
                    case "229":
                        screen.nextScreen = "MLP.qml";
                        break;
                    case "230":
                        screen.nextScreen = "Resurfacing_SingleSpot.qml";
                        break;
                    case "231":
                        screen.nextScreen = "profractionalUI.qml";
                        break;
                    case "232":    // M:s232=%s,T:screen.nextScreen=jouleFiberMenu.qml
                        screen.nextScreen = "jouleFiberMenu.qml";
                        break;

                    case "237":
                        screen.showErrorDialogMenu = true;
                        break;
                    case "239":
                        screen.nextScreen = "bblStartupMenu.qml";
                        break;
                    case "240":
                        screen.nextScreen = "jouleLaserSafetyMenu.qml";
                        break;
                    case "241":
                        screen.nextScreen = "jouleArmApp1064Menu.qml"
                        break;
                    case "242":
                        screen.nextScreen = "ScanGalvoCenterUI.qml"
                        break;
                    case "243":
                        screen.nextScreen = "ClearScan1064.qml"
                        break;
                    case "244":
                        screen.nextScreen = "SingleSpot1064.qml"
                        break;
                    case "245":
                        screen.nextScreen = "PhotoRevelation1064.qml"
                        break;
                    case "246":
                        screen.nextScreen = "ClearSense1064Menu.qml"
                        break;
                    case "247":
                        screen.nextScreen = "ClearToeApp.qml"
                        break;
                    case "248":
                        screen.nextScreen = "ClearSenseWartsApp.qml"
                        break;
                    case "249":
                        screen.nextScreen = "jouleArmApp1319Menu.qml"
                        break;
                    case "250":
                        screen.nextScreen = "ThermaScan1319App.qml"
                        break;
                    case "251":
                        screen.nextScreen = "jouleHybridMenu.qml"
                        break;
                    case "252":
                        screen.nextScreen = "diVaApp.qml"
                        break;
                    case "253":    // UI_MSG_S_JOULE_FIBER_ENDOVASC_APP
                        screen.nextScreen = "jouleFiberEndoVasc.qml"
                        break;
                    case "254":    // UI_MSG_S_JOULE_FIBER_CELLUSM_APP
                        screen.nextScreen = "jouleFiberCellusmooth.qml"
                        break;
                    case "255":    // UI_MSG_S_JOULE_FIBER_PROLIPO_APP
                        screen.nextScreen = "jouleFiberProLipo.qml"
                        break;
                    case "256":
                        screen.nextScreen = "bblTopMenu_new.qml"
                        break;
                    case "257":
                        screen.nextScreen = "bblForeverClearApp.qml"
                        break;
                    case "258":
                        screen.nextScreen = "bblForeverYoungApp.qml"
                        break;
                    case "259":
                        screen.nextScreen = "bblIdealImgSplash.qml"
                        break;
                    case "260":
                        screen.nextScreen = "bblIdealImgMainMenu.qml"
                        break;
                    case "261":
                        screen.nextScreen = "bblVascMenuIdealImage.qml"
                        break;
                    case "262":
                        screen.nextScreen = "bblVasRosDlgIdealImage.qml"
                        break;
                    case "263":
                        screen.nextScreen = "bblPigmentDlgIdealImage.qml"
                        break;
                    case "264":
                        screen.nextScreen = "bblsubMenu_IImageVascBody.qml"
                        break;
                    case "265":
                        screen.nextScreen = "bblFYVascularMenu.qml"
                        break;
                    case "266":
                        screen.nextScreen = "bblFYVasBodyMenu.qml"
                        break;

                    case "270":
                        screen.nextScreen = "HaloMainMenu.qml"
                        break;
                    case "271":
                        screen.nextScreen = "HaloMapperDlg.qml"
                        break;
                    case "272":
                        screen.nextScreen = "HaloApp.qml"
                        btnPrevious.visible = false;
                        break;
                    case "273":
                        screen.nextScreen = "HaloSummaryPage.qml"
                        break;

                        // these screens are not application nor services types.
                        // their enumeration starts at 200 in controller code.
                        // the controller add the screen number by 200 because
                        // there is a base of 200 when passing the screen no. to the Reach display
                        // Thus the screen ID in qml would have 400... and so on.
                        // the Translate file should have entries:
                        // M:s400=%s,T:screen.nextScreen=ScitonScreen.qml
                        // M:s401=%s,T:screen.nextScreen=ScitonTemplate.qml
                        // M:s402=%s,T:screen.nextScreen=experiment.qml
                        // and in qml file, screenID: 400, 401, 402, ... and so on

                    case "400":
                        screen.nextScreen = "ScitonScreen.qml"
                        break;
                    case "401":
                        screen.nextScreen = "ScitonTemplate.qml"
                        break;
                    case "402":
                        screen.nextScreen = "experiment.qml"    // for test only
                        break;

                    case "501":
                        screen.nextScreen = "ServiceLaserMenu.qml";
                        break;
                    case "502":
                        screen.nextScreen = "serviceLaserJustFireEm.qml";
                        break;
                    case "503":
                        screen.nextScreen = "ServiceLaserConfiguration.qml";
                        break;
                    case "504":
                        screen.nextScreen = "ServiceLaserEepromData.qml";
                        break;
                    case "506":
                        screen.nextScreen = "ServiceTopMenu.qml";
                        break;
                    case "507":
                        screen.nextScreen = "ServiceSystemConfiguration.qml";
                        break;
                    case "508":
                        screen.nextScreen = "ServiceLicenseKeys.qml";
                        break;
                    case "509":
                        screen.nextScreen = "ServiceSystemAccessories.qml";
                        break;
                    case "510":
                        screen.nextScreen = "ServiceHaloDivaMenu.qml";
                        break;
                    case "511":
                        screen.nextScreen = "ServiceMenuForCustomers.qml";
                        break;
                    case "512":
                        screen.nextScreen = "ServicePartnersProgram.qml";
                        break;
                    case "513":
                        screen.nextScreen = "ServiceRentToOwn.qml";
                        break;
                    case "520":
                        screen.nextScreen = "ServiceBblMainMenu.qml";
                        break;
                    case "521":
                        screen.nextScreen = "ServiceBblBurninMenu.qml";
                        break;
                    case "522":
                        screen.nextScreen = "ServiceErrorLog.qml";
                        break;
                    default:
                        txtEmulator.text = "Screen not found.";
                }
            }
            else if (values[0].charAt(0) === 'p')
            {
                switch (values[0])
                {
                    case "p1":
                        screen.fluence = values[1];
                        break;
                    case "p2":
                        screen.laserWidth = values[1];
                        break;
                    case "p3":
                        screen.rate = values[1];
                        break;
                    case "p4":
                        screen.timeRepeat = values[1];
                        break;
                    case "p5":
                        screen.temperature = values[1];
                        break;
                    case "p6":
                        screen.actualTemperature = values[1];
                        break;
                    case "p7":
                        screen.averagePower = values[1];
                        break;
                    case "p8":
                        screen.accumulatedTime = values[1];
                        break;
                    case "p9":
                        screen.accumulatedEnergy = values[1];
                        break;                        
                    case "p10":
                        screen.standbyMode = values[1];
                        break;
                    case "p11":     // UI_MSG_P_COUNTER
                        screen.counter = values[1];
                        break;
                    case "p12":
                        screen.pulseMode = values[1];
                        break;
                    case "p13":
                        screen.postCooling = values[1];
                        break;
                    case "p14":
                        screen.adapterValue = values[1];
                        break;
                    case "p15":
                        screen.time = values[1];
                        break;
                    case "p16":
                        screen.treatmentAreaID = values[1];
                        break;
                    case "p17":
                        screen.volume = values[1];
                        break;
                    case "p18":
                        screen.intensity = values[1];
                        break;
                    case "p19":
                        screen.area = values[1];
                        break;
                    case "p20":
                        screen.skinTypeID = values[1];
                        break;
                    case "p21":
                        screen.skinColorID = values[1];
                        break;
                    case "p22":
                        screen.hairColorID = values[1];
                        break;
                    case "p23":
                        screen.hairDiameterID = values[1];
                        break;
                    case "p24":
                        screen.hairDensityID = values[1];
                        break;

                    case "p25":
                        screen.genericData1 = values[1];
                        break;
                    case "p26":
                        screen.genericData2 = values[1];
                        break;
                    case "p27":
                        screen.genericData3 = values[1];
                        break;
                    case "p28":
                        screen.genericData4 = values[1];
                        break;
                    case "p29":
                        screen.genericData5 = values[1];
                        break;
                    case "p30":
                        screen.genericData6 = values[1];
                        break;
                    case "p31":
                        screen.genericData7 = values[1];
                        break;
                    case "p32":
                        screen.genericData8 = values[1];
                        break;

                    case "p33":
                        screen.treatmentAreaValue = values[1];
                        break;
                    case "p34":
                        screen.skinTypeValue = values[1];
                        break;
                    case "p35":
                        screen.skinColorValue = values[1];
                        break;
                    case "p36":
                        screen.hairColorValue = values[1];
                        break;
                    case "p37":
                        screen.hairDiameterValue = values[1];
                        break;
                    case "p38":
                        screen.hairDensityValue = values[1];
                        break;
                    case "p39":
                        screen.hairAreaValue = values[1];
                        break;
                    case "p40":
                        screen.targetEnergy = values[1];
                        break;
                    case "p41":
                        screen.subTitle = values[1];
                        break;
                    case "p42":
                        screen.new_system_message = values[1];
                        break;
                    case "p43":
                        screen.btnTopMenuArm_active = values[1];
                        break;
                    case "p44":
                        screen.btnTopMenuFiber_active = values[1];
                        break;
                    case "p45":
                        screen.btnTopMenuBbl_active = values[1];
                        break;
                    case "p46":
                        screen.btnArm2940_active = values[1];
                        break;
                    case "p47":
                        screen.btnArm1470_active = values[1];
                        break;
                    case "p48":
                        screen.btnArm1064_active = values[1];
                        break;
                    case "p49":
                        screen.btnArm1319_active = values[1];
                        break;
                    case "p50":
                        screen.btnArm755_active = values[1];
                        break;
                    case "p51":
                        screen.ablateTroughValue = values[1];
                        break;
                    case "p52":
                        screen.coagTroughValue = values[1];
                        break;
                    case "p53":
                        screen.swScannerShapeValue = values[1];
                        break;
                    case "p54":
                        screen.swScannerSizeValue = values[1];
                        break;
                    case "p55":
                         screen.sr_trlRepeaterValue = values[1];
                        break;
                    case "p56":
                         screen.troughAblateFluValue = values[1];
                        break;
                    case "p57":
                         screen.precision1 = values[1];
                        break;
                    case "p58":
                         screen.precision2 = values[1];
                        break;
                    case "p59":
                        screen.adapterID = values[1];
                        break;
                    case "p60":
                        screen.ablateDepthValue = values[1];
                        break;
                    case "p61":
                        screen.coagDepthValue = values[1];
                        break;
                    case "p62":
                        screen.clearAdapterCheck= values[1];
                        break;
                    case "p63":     // for button image update
                        screen.mlpDepthLevel = values[1];
                        break;
                    case "p64":     // for trough depth image update
                        screen.troughDepthValue = values[1];
                        break;
                    case "p65":
                        screen.mlpOverlapValue = values[1];
                        break;
                    case "p66":
                        screen.trlAimLevel = values[1];
                        break;
                    case "p67":
                        screen.txt_TRLhandpiece = values[1];
                        break;
                    case "p68":
                        screen.scannerPositionSelect = values[1];
                        break;
                    case "p69":
                        screen.scannerDirectionSelect = values[1];
                        break;
                    case "p70":
                        screen.mlpOverlap = values[1];
                        break;
                    case "p71":
                        screen.scannerArrayType = values[1];
                        break;
                    case "p72":
                        screen.spotsPitch = values[1];
                        break;
                    case "p73":
                        screen.coverage250Enable = values[1];
                        break;
                    case "p74":
                        screen.coverageXCEnable = values[1];
                        break;
                    case "p75":
                        screen.coagEnable = values[1];
                        break;
                    case "p76":
                        screen.unitmeasure = values[1];
                        break;
                    case "p77":
                        screen.treatCoverage = values[1];
                        break;
                    case "p78":
                        screen.treatDensity = values[1];
                        break;
                    case "p79":
                        screen.arrayCtrlEnable = values[1];
                        break;
                    case "p80":
                        screen.enableGeneric = values[1];   //
                        break;
                    case "p81":
                        screen.zoomlense = values[1];       // string: "xmm"
                        break;
                    case "p82":
                        screen.ctrl_Emulate = values[1];    // int: update emulation button image
                        break;
                    case "p83":
                        screen.txtScanGalvoAlignHorz = values[1];   // update the text
                        break;
                    case "p84":
                        screen.txtScanGalvoAlignVert = values[1];   // update the text
                        break;
                    case "p85":
                        screen.valHorz = values[1];         // M:p85=%s,T:screen.valHorz=%s
                        break;
                    case "p86":
                        screen.valVert = values[1];         // M:p86=%s,T:screen.valVert=%s
                        break;
                    case "p87":
                        screen.subTxt = values[1];         // M:p87=%s,T:screen.subTxt=%s
                        break;
                    case "p88":
                        screen.handpieceImage = values[1];  // M:p88=%s,T:screen.handpieceImage=%s
                        break;
                    case "p89":
                        screen.blinkLaserSym = values[1];   // M:p89=%s,T:screen.blinkLaserSym=%s
                        break;
                    case "p90":
                            screen.monostate = values[1];    // M:p90=%s,T:screen.monostate=%s
                        break;
                    case "p91":
                        screen.generic_Val1 = values[1];     // M:p91=%s,T:screen.generic_Val1=%s
                        break;
                    case "p92":
                        screen.generic_Val2 = values[1];     // M:p92=%s,T:screen.generic_Val2=%s
                        break;
                    case "p93":
                        screen.generic_Val3 = values[1];     // M:p93=%s,T:screen.generic_Val3=%s
                        break;
                    case "p94":
                        screen.subWarning = values[1];
                        break;
                    case "p95":
                        spkVolume = values[1];
                        break;
                    case "p96":
                        skinTyteIcon = values[1];
                        break;
                    case "p97":
                        screenActiveApp = values[1];
                        break;
                    case "p98":
                        audiophile = values[1];
                        break;
                    case "p99":
                        screenActiveSvc = values[1];
                        break;

                    case "p101":
                        errorDialogMenu.errorIdVal = values[1];
                        break;
                    case "p106":
                        errorDialogMenu.btnClearError = values[1];
                        break;

                    case "p111":
                        screen.btn_BBL_FC = values[1];
                        break;
                    case "p112":
                        screen.btn_BBL_FY = values[1];
                        break;
                    case "p115":
                        screen.btn_BBL_HR = values[1];
                        break;
                    case "p118":
                        screen.btn_BBL_ACNE = values[1];
                        break;

                    case "p101":
                        errorDialogMenu.errorIdVal = values[1];
                        break;
                    case "p102":
                        errorDialogMenu.errorDescr = values[1];
                        break;
                    case "p103":
                        errorDialogMenu.message = values[1];
                        break;
                    case "p109":
                        screen.screen_no_debug = values[1];
                        break;
                    case "p110":
                        screen.svc_screen_no_debug = values[1];
                        break;
                    case "p130":
                        screen.generic130 = values[1];
                        break;
                    case "p131":
                        screen.generic131 = values[1];
                        break;

                    case "p140":
                        screen.generic140 = values[1];
                        break;
                    case "p141":
                        screen.generic141 = values[1];
                        break;
                    case "p142":
                        screen.generic142 = values[1];
                        break;
                    case "p143":
                        screen.generic143 = values[1];
                        break;
                    case "p144":
                        screen.generic144 = values[1];
                        break;
                    case "p145":
                        screen.generic145 = values[1];
                        break;
                    case "p160":
                        screen.generic160 = values[1];
                        break;
                    case "p161":
                        screen.generic161 = values[1];
                        break;
                    case "p162":
                        screen.generic162 = values[1];
                        break;

                    case "p170":
                        screen.uiSlider0Value = values[1];
                        break;
                    case "p171":
                        screen.uiSlider1Value = values[1];
                        break;
                    case "p172":
                        screen.uiSlider2Value = values[1];
                        break;
                    case "p173":
                        screen.uiSlider3Value = values[1];
                        break;
                    case "p180":
                        screen.uiSlider0FlexMax = values[1];
                        break;
                    case "p181":
                        screen.uiSlider1FlexMax = values[1];
                        break;
                    case "p182":
                        screen.uiSlider2FlexMax = values[1];
                        break;
                    case "p183":
                        screen.uiSlider3FlexMax = values[1];
                        break;

                    case "p888":
                        screen.password_INQUIRY = values[1];   // code entry
                        break;

                    case "p200":
                        screen.laserSafetyWvlen = values[1];
                        break;
                    case "p201":
                        screen.msgBodyMessage = values[1];
                        break;
                    case "p202":
                        screen.msgWavelengthType = values[1];
                        break;
                    case "p203":
                        screen.msgSafetyGlasses = values[1];
                        break;
                    case "p1615":
                        screen.align1_nearFarField = values [1];
                        break;
                    case "p1616":
                        screen.align1_sweepRatioValue = values [1];
                        break;
                    case "p1640":
                        screen.srvcAlignCalibVal = values [1];
                        break;
                    case "p2082":
                        screen.srvcErrLogUserParams = values [1];
                        break;
                    case "p2149":
                        screen.licenseBblFastRate = values[1];
                        break;
                    case "p2357":
                        screen.srvcPPhpnv = values[1];
                        break;
                    case "p2358":
                        screen.srvcPPcode1 = values[1];
                        break;
                    case "p2361":
                        screen.srvcPPinvoiceCodes = values[1];
                        break;
                    case "p2362":
                        screen.srvcPPinvoiceCodes_Y2 = values[1];
                        break;
                    case "p2363":
                        screen.srvcPPinvoiceCodes_Y3 = values[1];
                        break;
                    case "p2364":
                        screen.srvcPPinvoiceCodes_Y4 = values[1];
                        break;
                    default:
                        txtEmulator.text = "Property not found.";
                        break;
                }

            }
        }
    }

    /********************** End Controls for Windows Emulation **********************/
    Timer {
        id: id_screenBuild
            interval: screenBuildTimer
            running: false
            repeat: false
            onTriggered: {
                running = false;
//                console.log(screenActiveApp)
//                console.log("timer done")
                screenActiveApp = 1;
//                console.log(screenActiveApp)
            }
    }

    Component.onCompleted: {
        // the layer is now atop of the laser symbol...
        id_blinky.z = 1;     // thus re-surface it's stack on top
        id_screenBuild.running = true;
        echoScreenToMCU(screenID, "00000")
//        screenActiveApp = 1;
    }
}

import QtQuick 2.0
import "../components"

/*!
    \qmltype ScreenFLuenceWidthTemperature
    \inqmlmodule components
    \brief This element is used as the base element for screens that need to display Fluence, Width and Temperature
           controls.

     The ScreenFLuenceWidthTemperature contains elements that are reused on many screens.
     Fluence, Width, Temperature, Counter, and the Time Repeat.
*/

Screen{
    id: screen
    bgImage: ""
    applyButtonVisible: false
    btnPrevious_Enable: true
    textHeadingColor: "white"
    bottomLayerVisible: true

    screenBuildTimer: 3000

    property int iconHeightDefault: 70
    property int iconWidthDefault: 70

    property int presetLocX: 50
    property int presetLocY: 530

    /*!
        The actualTemperature property will be changed when property id 6 is sent from the MCU, and will fire an event
        that will change the Temperature element actualTemperature.
    */
    property alias actualTemperature: m_temperature.actualTemperature
    /*!
        The temperature property will be changed when property id 5 is sent from the MCU, and will fire an event
        that will change the Temperature element value.
    */
    property alias temperature: m_temperature.value
    /*!
        The laserWidth property will be changed when property id 2 is sent from the MCU, and will fire an event
        that will change the NumericSelector element value.
    */
    property alias laserWidth: m_width.value
    /*!
        The fluence property will be changed when property id 1 is sent from the MCU, and will fire an event
        that will change the NumericSelector element value.
    */
    property alias fluence: m_fluence.value
    /*!
        The counter property will be changed when property id 11 is sent from the MCU, and will fire an event
        that will change the Counter element value.
    */
    property alias counter: m_counter.value
    /*!
        The timeRepeat property will be changed when property id 4 is sent from the MCU, and will fire an event
        that will change the ScitonRepeater element value.
    */
    property alias rate: m_repeat.value
    /*!
        Determines if the ScitonRepeat control is visible
    */
    property bool timeRepeatVisible: true

    property int treatmentArea: 0
    property int skinType:  0

    property alias silenceCtrl: screen.monostate

    property int yPos: 190

    property int rowAdjust: 20

    startaudio: 10

   // property int silenceCtrl: -1
    onSilenceCtrlChanged: {
        m_temperature.silenceCtrl = silenceCtrl;
         m_temperature.silenceCtrl = 1;
    }

    Temperature{
        id: m_temperature
        x: 730
        y: 158 - (rowAdjust/2)
        min: 1
        max: 30
        increaseEvent: 7
        decreaseEvent: 8
        propertyID: 5
        actualTemperaturePropertyID: 6
        precision: 0
    }

    NumericSelector{
        id: m_fluence
        x: 40
        y: 170 - rowAdjust
        textTitle: "Fluence"
        unitMeasure: "(J/cm\u00b2)"
        txtCtlHorizMargin: -20
        txtTitleHorizMargin: -20
        min: 1
        max: 100
        increaseEvent: 3
        decreaseEvent: 4
        propertyID: 1
        precision: 0
    }

    NumericSelector{
        id: m_width
        x: 280
        y: 170 - rowAdjust
        textTitle: "Width"
        unitMeasure: "(msec)"
        txtCtlHorizMargin: -35
        txtTitleHorizMargin: -20
        min: 1
        max: 500
        precision: 0
        increaseEvent: 5
        decreaseEvent: 6
        propertyID: 2
    }

    ScitonRepeater{
        id: m_repeat
        x: 530
        y: 168 - rowAdjust
        objectName: "repeat"
        min: 0
        max: 5
        unitMeasure: "s"
        eventID: 9
        propertyID: 3
        fontFamily: screen.fontFamily
        visible: timeRepeatVisible
    }

    Counter{
        id: m_counter
        anchors.rightMargin: 35
        anchors.bottom: screen.bottom
        anchors.bottomMargin: 130
//        anchors.bottomMargin: 15
        anchors.right: screen.layerImage.right
        eventID: 12
        propertyID: 11
        fontFamily: screen.fontFamily
    }
}

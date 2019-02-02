import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0

Rectangle {
    id: rectPTSpotifyRoot
    visible: false
    border.color: "#0921df"
    //        x: 7
    //        y: 565
    width: 1054
    height: 394
    color: "transparent"
    anchors.horizontalCenter: ptRectArea.horizontalCenter
    anchors.bottom: ptRectArea.bottom
    anchors.bottomMargin: 3

    Flickable {
        id: flkSpotCats
        property int selected: -1
        property string selectedCat: SpotifyPT.getSelectedCategory()
        height: 273
        width: rectPTSpotifyRoot.width - 2
        boundsBehavior: Flickable.DragOverBounds
        flickableDirection: Flickable.HorizontalFlick
        maximumFlickVelocity: 4500
        anchors.right: parent.right
        anchors.rightMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.top: parent.top
        anchors.topMargin: 3
        onVisibleChanged: { if(visible) {
                                selected=-1
                                selectedCat=""
                          }
        }
        focus: true
        contentWidth: 15000  //# Categories * width
        Row {
            spacing: 16
            Repeater {
                id: repCategories
                Rectangle {
                    id: rectItem
                    width: 265
                    height: 265
                    color: "#000000"
                    onActiveFocusChanged: if(!activeFocus){
                                              glowBorderCat.visible=false
                                          }
                    RectangularGlow {
                        visible: flkSpotCats.selected == index
                        id: glowBorderCat
                        anchors.fill: rectItem
                        glowRadius: 40
                        spread: 0.2
                        color: "orange"
                        cornerRadius: 25
                        opacity: flkSpotCats.selected == index

                    }

                    MouseArea {
                        id: mouseAreaItem
                        anchors.fill: parent
                        onClicked: {
                            btnPress.play()
                            flkSpotCats.selected = index
                             SpotifyPT.setCategory(index)
                            flkSpotCats.selectedCat=SpotifyPT.getSelectedCategory()
                            glowBorderCat.visible=true
                            SpotifyPT.getSubCategories()
                        }
                    }

                    Image {
                        id: imgCat
                        width: 265
                        height: 265
                        source: SpotifyPT.getCategoryImageUrl(index)
                        Label{
                            id: catLabel
                            color: "white"
                            font.pointSize: 24
                            text: SpotifyPT.getCategoryName(index)
                            anchors.bottom: imgCat.bottom
                            anchors.bottomMargin: 40
                            anchors.horizontalCenter: imgCat.horizontalCenter
                        }
                    }
                    Component.onCompleted: {
//                                                  if(SpotifyPT.getSelectedCategoryIndex() == index){
//                                                     glowBorderCat.visible=true
//                                                     flkSpotCats.contentX = (flkSpotCats.selected * 281) - 400
//                                                  } else
                                                flkSpotCats.selected=-1
                                                flkSpotCats.selectedCat=""
                                                 glowBorderCat.visible=false
                    }
                } // Rectangle
            } // Repeater
        }  // Row
    } // Flickable Cats
} // rectPTSpotify


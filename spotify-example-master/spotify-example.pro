TEMPLATE = app
QT += qml quick widgets multimedia network sql xml
QMAKE_RESOURCE_FLAGS += -no-compress

#    A T T E N T I O N
# 1. I use it on test aplication on desktop
VV_TEST = 0
equals(VV_TEST, 1) {
  DEFINES += VV_TEST
}
# 2. set to 0 if desktop
EMBEDDED_DEV = 1

equals(EMBEDDED_DEV, 1) {
   QTPLUGIN += qtvirtualkeyboardplugin
   DEFINES += EMBEDDED_DEV
   message("we are building EMBEDDED version...")
} else {
   message("we are building DESKTOP version...")
}

SOURCES += spotify-example.cc \
    spotify-player.cc
HEADERS += spotify-player.h

equals(EMBEDDED_DEV, 1) {

SDKTARGETSYSROOT=/home/dev/Qt/5.6/Boot2Qt/colibri-imx6/toolchain/sysroots/armv7ahf-vfp-neon-poky-linux-gnueabi
message("SDKTARGETSYSROOT is " + $$SDKTARGETSYSROOT)

INCLUDEPATH +=  $$SDKTARGETSYSROOT/usr/include
INCLUDEPATH +=  $$SDKTARGETSYSROOT/usr/include/gstreamer-1.0
INCLUDEPATH +=  $$SDKTARGETSYSROOT/usr/include/glib-2.0

QMAKE_LIBDIR +=  $$SDKTARGETSYSROOT/usr/lib
QMAKE_LIBDIR +=  $$SDKTARGETSYSROOT/usr/lib/pulseaudio

LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lcdio_cdda
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lcdio
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -ldiscid
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lcoverart
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lcoverartcc
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lmusicbrainz5

LIBS += -L $$SDKTARGETSYSROOT/usr/lib -ljson-c
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lpulse
LIBS += -L $$SDKTARGETSYSROOT/usr/lib -lpulse-mainloop
# LIBS += -L $$SDKTARGETSYSROOT/usr/lib/pulseaudio -lpulsecommon-6.0
LIBS += -L/home/dev/Qt/5.6/Boot2Qt/colibri-imx6/toolchain/sysroots/armv7ahf-vfp-neon-poky-linux-gnueabi/usr/lib/pulseaudio/ -lpulsecommon-6.0

target.path = /opt/magna
INSTALLS += target

} else {

  equals(VV_TEST, 1) {
    message("we are building DESKTOP VV_TEST version...")

    LIBS += -lcdio_cdda
    LIBS += -lcdio
    LIBS += -ldiscid
    LIBS += -lpulse
    LIBS += -lpulse-mainloop-glib
    LIBS += -lcoverart
    LIBS += -lcoverartcc
    # VV
    LIBS += -lmusicbrainz5
    LIBS += -lmusicbrainz5cc
  } else {
    include(deployment.pri)

    INCLUDEPATH += $$PWD/../../../../usr/local/include
    DEPENDPATH += $$PWD/../../../../usr/local/include
    INCLUDEPATH += $$PWD/../../../usr/include
    DEPENDPATH += $$PWD/../../../usr/include

    unix:!macx: LIBS += -L$$PWD/../../../../usr/lib/ -lcdio_cdda

    win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../../usr/lib/release/ -lcdio
    else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../../usr/lib/debug/ -lcdio
    else:unix: LIBS += -L$$PWD/../../../usr/lib/ -lcdio

    win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../../../usr/local/lib/release/ -ldiscid
    else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../../../usr/local/lib/debug/ -ldiscid
    else:unix: LIBS += -L$$PWD/../../../../usr/local/lib/ -ldiscid

    win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../../../usr/local/lib/release/ -lmusicbrainz5
    else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../../../usr/local/lib/debug/ -lmusicbrainz5
    else:unix: LIBS += -L$$PWD/../../../../usr/local/lib/ -lmusicbrainz5

    win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../../../usr/local/lib/release/ -lcoverart
    else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../../../usr/local/lib/debug/ -lcoverart
    else:unix: LIBS += -L$$PWD/../../../../usr/local/lib/ -lcoverart

    unix: PKGCONFIG += libpulse-mainloop-glib

  }
}

CONFIG += c++11 debug

CONFIG += link_pkgconfig
PKGCONFIG += gstreamer-1.0 gstreamer-audio-1.0 gstreamer-app-1.0
#libspotify

TARGET = spotify-example


FROM alpine:3.17 as  builder
ENV SQLITE3SRCDIR='/tmp/phantomjs/src/qt/qtbase/src/3rdparty/sqlite'
ENV OPENSSL_FLAGS='no-idea no-mdc2 no-rc5 no-zlib enable-tlsext no-ssl2 no-ssl3 no-ssl3-method enable-rfc3779 enable-cms no-tests   '
ENV OPENSSL_PLATFORM='linux-generic64'
WORKDIR /tmp
RUN echo "Install deps..." && \
    time apk add --quiet --no-cache --virtual build-dependencies \
#   Main deps
    git python3 patch make g++ perl linux-headers \
#   QWebKit deps
    flex bison gperf ruby \
#   font deps
    freetype-static fontconfig-static libc-dev; \
    echo "Build ICU ..."; \
    wget -q https://github.com/unicode-org/icu/archive/refs/tags/release-52-1.tar.gz && \
     tar -xf release-52-1.tar.gz && cd icu-release-52-1/icu4c/source && \
       ./configure --prefix=/usr --enable-static --disable-shared && \
       make -s -j 2 >/dev/null && make install && cd /tmp && \
    echo "Build OpenSSL ..."; \
    [ $(uname -m) == "x86_64" ] && export OPENSSL_PLATFORM="linux-x86_64"; \
    wget -q https://www.openssl.org/source/old/1.0.1/openssl-1.0.1t.tar.gz && \
      tar -xf openssl-1.0.1t.tar.gz && cd openssl-1.0.1t && \
      ./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib ${OPENSSL_FLAGS} ${OPENSSL_PLATFORM} && \
      make -s -j 2 depend >/dev/null && make -j 4 && make install_sw && cd /tmp && \
    echo "Clone PhantomJS ..."; \
    git config --global advice.detachedHead false && \
    time git clone -q --depth=1 --branch=2.1.1 --single-branch --recurse-submodules --shallow-submodules https://github.com/ariya/phantomjs.git; \
    echo "Fetch Patches ..."; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/01-qt-sockl.patch; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/02-execinfo.patch; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/03-bison-cssgrammar.patch; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/04-bison-xpathgrammar.patch; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/05-backtrace-qlogging.patch; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/XPathGrammar.h; \
    wget -q https://raw.githubusercontent.com/stck/phantomjs-arm/master/06-udis-py.patch; \
    cd /tmp/phantomjs && \
    patch -f /tmp/phantomjs/src/qt/qtbase/src/corelib/global/qlogging.cpp /tmp/05-backtrace-qlogging.patch && \
    patch -p1 /tmp/phantomjs/src/qt/qtbase/mkspecs/linux-g++/qplatformdefs.h /tmp/01-qt-sockl.patch && \
    patch -f /tmp/phantomjs/src/qt/qtwebkit/Source/WTF/wtf/Assertions.cpp /tmp/02-execinfo.patch && \
    patch -f /tmp/phantomjs/src/qt/qtwebkit/Source/WebCore/css/makegrammar.pl /tmp/03-bison-cssgrammar.patch && \
    patch -f /tmp/phantomjs/src/qt/qtwebkit/Source/WebCore/DerivedSources.pri /tmp/04-bison-xpathgrammar.patch && \
    mkdir -p /tmp/phantomjs/src/qt/qtwebkit/Source/WebCore/generated && \cp /tmp/XPathGrammar.h /tmp/phantomjs/src/qt/qtwebkit/Source/WebCore/generated && \
    patch -f /tmp/phantomjs/src/qt/qtwebkit/Source/JavaScriptCore/disassembler/udis86/ud_opcode.py /tmp/06-udis-py.patch; \
    echo "Build QTBase"; \
    cd /tmp/phantomjs/src/qt/qtbase && \
     ./configure -static -opensource -confirm-license -prefix $(pwd) -qt-zlib -qt-libpng -qt-libjpeg -qt-pcre -nomake examples -nomake tools -nomake tests -no-qml-debug -no-dbus -no-opengl -no-audio-backend -D QT_NO_GRAPHICSVIEW -D QT_NO_GRAPHICSEFFECT -D QT_NO_STYLESHEET -D QT_NO_STYLE_CDE -D QT_NO_STYLE_CLEANLOOKS -D QT_NO_STYLE_MOTIF -D QT_NO_STYLE_PLASTIQUE -D QT_NO_PRINTPREVIEWDIALOG -qpa phantom -openssl -openssl-linked -no-openvg -no-eglfs -no-egl -no-glib -no-gtkstyle -no-cups -no-sm -no-xinerama -no-xkb -no-xcb -no-kms -no-linuxfb -no-directfb -no-mtdev -no-libudev -no-evdev -no-pulseaudio -no-alsa -no-feature-PRINTPREVIEWWIDGET -fontconfig -icu -release && \
     time make -s -j 2 >/dev/null && \
    echo "Build QTWebKit" && \
    cd /tmp/phantomjs/src/qt/qtwebkit && \
     ../qtbase/bin/qmake WEBKIT_CONFIG-=build_webkit2 WEBKIT_CONFIG-=netscape_plugin_api WEBKIT_CONFIG-=use_gstreamer WEBKIT_CONFIG-=use_gstreamer010 WEBKIT_CONFIG-=use_native_fullscreen_video WEBKIT_CONFIG-=video WEBKIT_CONFIG-=web_audio && \
     time make -s -j 2 >/dev/null && \
    echo "Build PhantomJS" && \
    cd /tmp/phantomjs/src && \
     ./qt/qtbase/bin/qmake && \
     time make -s -j 2 >/dev/null && \
#   Check PhantomJS
    cd /tmp/phantomjs/bin && ldd phantomjs && ./phantomjs --version && mv phantomjs /usr/bin/phantomjs && \
#   Cleanup
    cd /tmp && rm -rf *.patch *.h *.apk *.tar.gz icu-release* openssl* phantomjs && \
    apk del build-dependencies;

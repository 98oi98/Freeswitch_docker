FROM centos:7 

RUN yum  -y update

RUN yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release
RUN yum install -y git \
     alsa-lib-devel \ 
     lksctp-tools-devel \ 
     libdb-devel \
     libdb4* \
     libyuv-devel \
     libmpg123-devel \
     libshout-devel \
     lame-devel \
     autoconf \
     automake \
     bison \
     broadvoice-devel \
     bzip2 \
     curl-devel \
     e2fsprogs-devel \
     flite-devel \
     g722_1-devel \
     gcc-c++ \
     gdbm-devel \
     gnutls-devel \
     ilbc2-devel \
     ldns-devel \
     libcodec2-devel \
     libcurl-devel \
     libedit-devel \
     libidn-devel \
     libjpeg-devel \
     libmemcached-devel \
     libogg-devel \
     libsilk-devel \
     libsndfile-devel \
     libtheora-devel \
     libtiff-devel \
     libtool \
     libuuid-devel \
     libvorbis-devel \
     libxml2-devel \
     lua-devel \
     lzo-devel \
     mongo-c-driver-devel \
     ncurses-devel \
     net-snmp-devel \
     openssl-devel \
     opus-devel \
     pcre-devel \
     perl \
     perl-ExtUtils-Embed \
     pkgconfig \
     portaudio-devel \
     postgresql-devel \
     python-devel \
     soundtouch-devel \
     speex-devel \
     sqlite-devel \
     unbound-devel \
     unixODBC-devel \
     wget \
     which \
     yasm \
     nasm \
     zlib-devel 

WORKDIR /usr/local/src
RUN wget https://liquidtelecom.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
RUN tar -xvzf lame-3.100.tar.gz
RUN cd lame-3.100 && ./configure && make && make install && ldconfig 

WORKDIR /usr/local/src/
RUN git clone --progress https://github.com/signalwire/freeswitch.git -bv1.10 freeswitch
WORKDIR /usr/local/src/freeswitch
COPY modules.conf .
RUN ls
RUN ./bootstrap.sh -j 
RUN  ./configure -C --enable-portable-binary --enable-sctp \
               --prefix=/usr/local/freeswitch --bindir /usr/bin --sbindir /usr/sbin --localstatedir=/var --sysconfdir=/etc \
               --with-gnu-ld --with-python \
               --enable-core-odbc-support --enable-zrtp \
               --enable-core-pgsql-support
RUN make 
RUN ls | grep configure
RUN make -j install 
RUN make -j cd-sounds-install && make -j cd-moh-install

CMD ["/bin/freeswitch", "-conf", "/etc/freeswitch", "-log", "/var/log/freeswitch",  "-db", "/usr/local/freeswitch/db", " -nc", " -nonat"]
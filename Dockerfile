FROM alpine:edge

RUN apk add abuild
# abuild requirements
RUN apk add build-base expat-dev openssl-dev zlib-dev ncurses-dev bzip2-dev xz-dev sqlite-dev libffi-dev tcl-dev linux-headers gdbm-dev readline-dev bluez-dev
# additional pdal requirements
RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/main cmake eigen-dev hexer-dev nitro-dev gdal-dev geos-dev laz-perf-dev libgeotiff-dev libxml2-dev python3-dev py3-numpy-dev jsoncpp-dev hdf5-dev proj-dev cpd-dev fgt-dev sqlite-dev postgresql-dev curl-dev laszip-dev libspatialite-dev linux-headers libexecinfo-dev pcl-dev boost-dev nitro

WORKDIR /aports/testing/pdal
COPY APKBUILD APKBUILD

# add user for build
RUN adduser -S abuild -G abuild sudo
RUN chown -R abuild /aports/testing/pdal
USER abuild

# build
RUN abuild-keygen -a -n
RUN abuild -r

# test
USER root
RUN apk add --allow-untrusted /home/abuild/packages/testing/x86_64/pdal-2.0.1-r5.apk

#!/bin/sh

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# start jellybean
# 368864 = JRN61B
# end jellybean
BRANCH=jellybean
if test $BRANCH=jellybean
then
  ZIP=nakasi-ota-368864.zip
  BUILD=jrn61b
fi # jellybean
ROOTDEVICE=grouper
DEVICE=grouper
MANUFACTURER=asus

for COMPANY in unknown
do
  echo Processing files from $COMPANY
  rm -rf tmp
  FILEDIR=tmp/vendor/$COMPANY/$DEVICE/proprietary
  mkdir -p $FILEDIR
  mkdir -p tmp/vendor/$MANUFACTURER/$ROOTDEVICE
  case $COMPANY in
  unknown)
    TO_EXTRACT="\
            system/bin/btmacreader \
            system/bin/glgps \
            system/bin/sensors-config \
            system/bin/setup_fs \
            system/bin/tf_daemon \
            system/etc/asound.conf \
            system/etc/firmware/bcm4330.hcd \
            system/etc/firmware/nvavp_os_00001000.bin \
            system/etc/firmware/nvavp_os_0ff00000.bin \
            system/etc/firmware/nvavp_os_e0000000.bin \
            system/etc/firmware/nvavp_os_eff00000.bin \
            system/etc/firmware/nvavp_vid_ucode_alt.bin \
            system/etc/firmware/touch_fw.ekt \
            system/etc/gps/gpsconfig.xml \
            system/etc/nvcamera.conf \
            system/etc/nvram.txt \
            system/lib/egl/libEGL_tegra.so \
            system/lib/egl/libGLESv1_CM_tegra.so \
            system/lib/egl/libGLESv2_tegra.so \
            system/lib/hw/camera.tegra3.so \
            system/lib/hw/gps.tegra3.so \
            system/lib/hw/gralloc.tegra3.so \
            system/lib/hw/hwcomposer.tegra3.so \
            system/lib/hw/sensors.grouper.so \
            system/lib/libami.so \
            system/lib/libami_sensor_mw.so \
            system/lib/libardrv_dynamic.so \
            system/lib/libcgdrv.so \
            system/lib/libdrmdecrypt.so \
            system/lib/libmllite.so \
            system/lib/libmlplatform.so \
            system/lib/libmplmpu.so \
            system/lib/libnvapputil.so \
            system/lib/libnvasfparserhal.so \
            system/lib/libnvaviparserhal.so \
            system/lib/libnvavp.so \
            system/lib/libnvcamerahdr.so \
            system/lib/libnvddk_2d.so \
            system/lib/libnvddk_2d_v2.so \
            system/lib/libnvdispmgr_d.so \
            system/lib/libnvmm.so \
            system/lib/libnvmmlite.so \
            system/lib/libnvmmlite_audio.so \
            system/lib/libnvmmlite_image.so \
            system/lib/libnvmmlite_utils.so \
            system/lib/libnvmmlite_video.so \
            system/lib/libnvmm_audio.so \
            system/lib/libnvmm_camera.so \
            system/lib/libnvmm_contentpipe.so \
            system/lib/libnvmm_image.so \
            system/lib/libnvmm_manager.so \
            system/lib/libnvmm_misc.so \
            system/lib/libnvmm_parser.so \
            system/lib/libnvmm_service.so \
            system/lib/libnvmm_utils.so \
            system/lib/libnvmm_video.so \
            system/lib/libnvmm_writer.so \
            system/lib/libnvodm_dtvtuner.so \
            system/lib/libnvodm_hdmi.so \
            system/lib/libnvodm_imager.so \
            system/lib/libnvodm_misc.so \
            system/lib/libnvodm_query.so \
            system/lib/libnvomx.so \
            system/lib/libnvomxilclient.so \
            system/lib/libnvos.so \
            system/lib/libnvparser.so \
            system/lib/libnvrm.so \
            system/lib/libnvrm_graphics.so \
            system/lib/libnvsm.so \
            system/lib/libnvtvmr.so \
            system/lib/libnvwinsys.so \
            system/lib/libnvwsi.so \
            system/lib/libsensors.base.so \
            system/lib/libsensors.lightsensor.so \
            system/lib/libsensors.mpl.so \
            system/lib/libstagefrighthw.so \
            system/lib/libtf_crypto_sst.so \
            system/vendor/firmware/libpn544_fw.so \
            system/vendor/lib/drm/libdrmwvmplugin.so \
            system/vendor/lib/libwvdrm_L1.so \
            system/vendor/lib/libwvm.so \
            system/vendor/lib/libWVStreamControlAPI_L1.so
            "
    ;;
  esac
  echo \ \ Extracting files from OTA package
  for ONE_FILE in $TO_EXTRACT
  do
    echo \ \ \ \ Extracting $ONE_FILE
    unzip -j -o $ZIP $ONE_FILE -d $FILEDIR > /dev/null || echo \ \ \ \ Error extracting $ONE_FILE
    if test $ONE_FILE = system/vendor/bin/gpsd -o $ONE_FILE = system/vendor/bin/pvrsrvinit -o $ONE_FILE = system/bin/fRom
    then
      chmod a+x $FILEDIR/$(basename $ONE_FILE) || echo \ \ \ \ Error chmoding $ONE_FILE
    fi
    if test $(echo $ONE_FILE | grep \\.apk\$ | wc -l) = 1
    then
      echo \ \ \ \ Splitting $ONE_FILE
      mkdir -p $FILEDIR/$(basename $ONE_FILE).parts || echo \ \ \ \ Error making parts dir for $ONE_FILE
      unzip $FILEDIR/$(basename $ONE_FILE) -d $FILEDIR/$(basename $ONE_FILE).parts > /dev/null || echo \ \ \ \ Error unzipping $ONE_FILE
      rm $FILEDIR/$(basename $ONE_FILE) || echo \ \ \ \ Error removing original $ONE_FILE
      rm -rf $FILEDIR/$(basename $ONE_FILE).parts/META-INF || echo \ \ \ \ Error removing META-INF for $ONE_FILE
    fi
  done
  echo \ \ Setting up $COMPANY-specific makefiles
  cp -R $COMPANY/staging/* tmp/vendor/$COMPANY/$DEVICE || echo \ \ \ \ Error copying makefiles
  echo \ \ Setting up shared makefiles
  cp -R root/* tmp/vendor/$MANUFACTURER/$ROOTDEVICE || echo \ \ \ \ Error copying makefiles
  echo \ \ Generating self-extracting script
  SCRIPT=extract-$COMPANY-$DEVICE.sh
  cat PROLOGUE > tmp/$SCRIPT || echo \ \ \ \ Error generating script
  cat $COMPANY/COPYRIGHT >> tmp/$SCRIPT || echo \ \ \ \ Error generating script
  cat PART1 >> tmp/$SCRIPT || echo \ \ \ \ Error generating script
  cat $COMPANY/LICENSE >> tmp/$SCRIPT || echo \ \ \ \ Error generating script
  cat PART2 >> tmp/$SCRIPT || echo \ \ \ \ Error generating script
  echo tail -n +$(expr 2 + $(cat PROLOGUE $COMPANY/COPYRIGHT PART1 $COMPANY/LICENSE PART2 PART3 | wc -l)) \$0 \| tar zxv >> tmp/$SCRIPT || echo \ \ \ \ Error generating script
  cat PART3 >> tmp/$SCRIPT || echo \ \ \ \ Error generating script
  (cd tmp ; tar zc --owner=root --group=root vendor/ >> $SCRIPT || echo \ \ \ \ Error generating embedded tgz)
  chmod a+x tmp/$SCRIPT || echo \ \ \ \ Error generating script
  ARCHIVE=$COMPANY-$DEVICE-$BUILD-$(md5sum < tmp/$SCRIPT | cut -b -8 | tr -d \\n).tgz
  rm -f $ARCHIVE
  echo \ \ Generating final archive
  (cd tmp ; tar --owner=root --group=root -z -c -f ../$ARCHIVE $SCRIPT || echo \ \ \ \ Error archiving script)
  rm -rf tmp
done
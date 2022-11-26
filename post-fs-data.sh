#!/system/bin/sh

# TODO: Is this correct?
PRJ_NAME=$(getprop ro.oplus.image.my_product.type)
RUI_VER=$(getprop ro.build.version.realmeui)
TEMP_PATH="/cache/feature.xml"
LOG_PATH="/cache/realify.log"

# Functions 
cleanup_log()
{
    rm $LOG_PATH
}

log()
{
    echo $1 >> $LOG_PATH
}

remove_feature()
{
    log "Removing feature: ${1}"
    sed -i "/${1}/d" $TEMP_PATH
}

check_realmeui_ver()
{
    if [[ $RUI_VER == V2.0 ]]; then
        FEATURE_PATH="/my_product/etc/extension/appfeature_liteos.xml"
    elif [[ $RUI_VER == V3.0 ] || [ $RUI_VER == V4.0 ]]; then
        FEATURE_PATH="/my_product/etc/extension/realme_product_rom_extend_feature_${PRJ_NAME}.xml"
    else
        log "Unknown realmeUI version: ${RUI_VER}"
        exit 1
    fi
    log "Detected realmeUI Version: ${RUI_VER}"
    log "Target file: ${FEATURE_PATH}"
}

prepare_feature_list() 
{
    # Start by copying for modification
    cp $FEATURE_PATH $TEMP_PATH
}

remove_lowend_features()
{
    if [[ $RUI_VER == V2.0 ]]; then
        # Enables high end app launch animations
        remove_feature com.oppo.launcher.light_animator
        # Enables blur in the majority of the UI
        remove_feature com.android.systemui.gauss_blur_disabled
        # Disables "lightos" QS tiles
        remove_feature com.android.systemui.apply_light_os_qs_tile
    elif [[ $RUI_VER == V3.0 ] || [ $RUI_VER == V4.0 ]]; then
        # Enables high end app launch animations
        remove_feature com.android.launcher.light_animator
        # Enables blur in the majority of the UI
        remove_feature com.android.systemui.gauss_blur_disabled
        # Enables launcher card
        remove_feature com.android.launcher.card_disabled
        # Disables "lightos" sound recorder
        remove_feature com.oplus.soundrecorder.lightos
    fi
}

setup_mount()
{
    # Now, bind mount the resulting file to the original location
    log "Mounting ${TEMP_PATH} to ${FEATURE_PATH}"
    mount --bind $TEMP_PATH $FEATURE_PATH
}

# Run these in order
cleanup_log
check_realmeui_ver
prepare_feature_list
remove_lowend_features
setup_mount

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
    elif [[ $RUI_VER == V3.0 ]]; then
        FEATURE_PATH="/my_product/etc/extension/realme_product_rom_extend_feature_${PRJ_NAME}.xml"
    elif [[ $RUI_VER == V4.0 ]]; then
        FEATURE_PATH="/my_product/etc/extension/feature_com.coloros.oppoguardelf.xml"
    elif [[ $RUI_VER == V3.0 ]]; then
        FEATURE_PATH="/my_product/etc/extension/realme_product_rom_extend_feature_${PRJ_NAME}.xml"
    elif [[ $RUI_VER == V1.0 ]]; then
        FEATURE_PATH="/oppo_product/etc/permissions/com.oppo.features.os.xml"
    else
        log "Unknown realmeUI version: ${RUI_VER}"
        exit 1
    fi
    log "Detected realmeUI Version: ${RUI_VER}"
    log "Target file: ${FEATURE_PATH}"
}

prepare_feature_list() 
{
    # Check if the file exists
    if [[ -e "$FEATURE_PATH" ]]; then
        # Start by copying for modification
        cp $FEATURE_PATH $TEMP_PATH
    else
        log "${FEATURE_PATH} does not exist, exiting!"
        exit 1
    fi
}

remove_lowend_features()
{
    # Enables high end app launch animations
    remove_feature com.android.launcher.light_animator
    remove_feature com.oppo.launcher.light_animator
    remove_feature com.android.launcher.light_folder_animation
    # Enable Volume Blur
    remove_feature com.android.systemui.disable_volume_blur
    # Enables blur in the majority of the UI
    remove_feature com.android.systemui.gauss_blur_disabled
    remove_feature com.android.systemui.pan_view_gauss_blur_disabled
    # Enables launcher card
    remove_feature com.android.launcher.card_disabled
    # Disables "lightos" sound recorder
    remove_feature com.oplus.soundrecorder.lightos
    # Disables "lightos" QS tiles
    remove_feature com.android.systemui.apply_light_os_qs_tile
    # Enables SmartSidebar
    remove_feature com.oplus.smartsidebar.default.off
    remove_feature com.oplus.floatassistant.single_view
    remove_feature com.oplus.floatassistant.assistive_ball_disable
    # Enables Live Wallpapers
    remove_feature com.oppo.launcher.LIVE_WALLPAPER_ENTRY_DISABLED
    remove_feature com.oppo.launcher.OVERLAY_DISABLED
    remove_feature com.oppo.launcher.DRAW_MODE_APP_RANK_DISABLED
    remove_feature com.coloros.wallpapers.LIGHT_WEIGHT_OS_FUNC
    remove_feature com.android.wallpaper.livepicker.LIGHT_WEIGHT_OS_FUNC
    # Enables high-end charging animation
    remove_feature com.android.systemui.charge_lizi_anim_disable
    # Enables high-end gamespace features
    remove_feature com.coloros.gamespace_package_share_notsupport
    remove_feature com.coloros.gamespace_gameboard_notsupport
    remove_feature com.coloros.gamespace_game_focus_mode_notsupport
    # Disable OPPO LightOS (realmeUI 1)
    remove_feature oppo.sys.light.func
    remove_feature oppo.sys.light.func.os7_ext
    # Enable Multiuser support (RUI 1)
    remove_feature oppo.multiuser.entry.unsupport
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

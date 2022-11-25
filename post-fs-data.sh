#!/system/bin/sh

# TODO: Is this correct?
PRJ_NAME=$(getprop ro.oplus.image.my_product.type)
FEATURE_PATH="/my_product/etc/extension/realme_product_rom_extend_feature_${PRJ_NAME}.xml"
TEMP_PATH="/cache/feature.xml"

# Functions 
remove_feature()
{
    sed -i "/${1}/d" $TEMP_PATH
}

prepare_feature_list() 
{
    # Start by copying for modification
    cp $FEATURE_PATH $TEMP_PATH
}

remove_lowend_features()
{
    # Enables high end app launch animations
    remove_feature com.android.launcher.light_animator
    # Enables blur in the majority of the UI
    remove_feature com.android.systemui.gauss_blur_disabled
    # Enables launcher card
    remove_feature com.android.launcher.card_disabled
    # Disables "lightos" sound recorder
    remove_feature com.oplus.soundrecorder.lightos
}

setup_mount()
{
    # Now, bind mount the resulting file to the original location
    mount --bind $TEMP_PATH $FEATURE_PATH
}

# Run these in order
prepare_feature_list
remove_lowend_features
setup_mount

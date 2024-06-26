### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Kyuofox-Kernel
kernel.maintainer=Made by Github.com/Kyuofox
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=Redmi Note 12 Turbo
device.name2=POCO F5
device.name3=marble
device.name4=marblein
device.name5=
supported.versions=14
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=boot;
BOOT_SUFFIX="$(getprop ro.boot.slot_suffix)";
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install

# check ota
if [ -n "$(ls /data/gsi/ota)" ]; then
    case "$(getprop ro.boot.slot_suffix)" in
    _a)
        block="/dev/block/by-name/boot_b"
        ;;
    _b)
        block="/dev/block/by-name/boot_a"
        ;;
    esac
    ui_print "Detected OTA, set boot to $block"
    dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk
    write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
fi

# Patch vbmeta
ui_print " "
for vbmeta_blk in /dev/block/bootdevice/by-name/vbmeta${slot} /dev/block/bootdevice/by-name/vbmeta_system${slot}; do
 ui_print "- Patching ${vbmeta_blk} ..."
 ${bin}/vbmeta-disable-verification $vbmeta_blk || {
  ui_print "! Failed to patching ${vbmeta_blk}!"
  ui_print "- If the device won't boot after the installation,"
  ui_print "  please manually disable AVB in TWRP."
 }
done

## init_boot files attributes
#init_boot_attributes() {
#set_perm_recursive 0 0 755 644 $RAMDISK/*;
#set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
#} # end attributes

# init_boot shell variables
#BLOCK=init_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for init_boot patching
#reset_ak;

# init_boot install
#dump_boot; # unpack ramdisk since it is the new first stage init ramdisk where overlay.d must go

#write_boot;
## end init_boot install


## vendor_kernel_boot shell variables
#BLOCK=vendor_kernel_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for vendor_kernel_boot patching
#reset_ak;

# vendor_kernel_boot install
#split_boot; # skip unpack/repack ramdisk, e.g. for dtb on devices with hdr v4 and vendor_kernel_boot

#flash_boot;
## end vendor_kernel_boot install


## vendor_boot files attributes
#vendor_boot_attributes() {
#set_perm_recursive 0 0 755 644 $RAMDISK/*;
#set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
#} # end attributes

# vendor_boot shell variables
#BLOCK=vendor_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for vendor_boot patching
#reset_ak;

# vendor_boot install
#dump_boot; # use split_boot to skip ramdisk unpack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot

#write_boot; # use flash_boot to skip ramdisk repack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
## end vendor_boot install


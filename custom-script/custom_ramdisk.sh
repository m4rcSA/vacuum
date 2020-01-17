#!/bin/bash
# Put rrlog directory to RAM-disk

LIST_CUSTOM_PRINT_USAGE+=("custom_print_usage_ramdisk")
LIST_CUSTOM_PRINT_HELP+=("custom_print_help_ramdisk")
LIST_CUSTOM_PARSE_ARGS+=("custom_parse_args_ramdisk")
LIST_CUSTOM_FUNCTION+=("custom_function_ramdisk")
ENABLE_RAMDISK=${ENABLE_RAMDISK:-"0"}

function custom_print_usage_ramdisk() {
    cat << EOF

Custom parameters for '${BASH_SOURCE[0]}':
[--enable-ramdisk]
EOF
}

function custom_print_help_ramdisk() {
    cat << EOF

Custom options for '${BASH_SOURCE[0]}':
  --enable-ramdisk             Put rrlog directory to RAM-disk to prevent wearing out FLASH memory
EOF
}

function custom_parse_args_ramdisk() {
    case ${PARAM} in
        *-enable-ramdisk)
            ENABLE_RAMDISK=1
            ;;
        -*)
            return 1
            ;;
    esac
}

function custom_function_ramdisk() {
    if [ $ENABLE_RAMDISK -eq 1 ]; then
        RAMCLEANER_PATH=$(dirname $(readlink_f "${BASH_SOURCE[0]}"))
        if [ -r "$RAMCLEANER_PATH/ramdisk-cleaner.sh" ]; then
            sed -E -i '/exit 0$/iif [ -d \/mnt\/data\/rockrobo\/rrlog ]; then mount -t tmpfs -o size=5m tmpfs \/mnt\/data\/rockrobo\/rrlog; fi' "${IMG_DIR}/etc/rc.local"
            echo "+ Adding rrlogclean.sh"
            install -D -m 0755 "${RAMCLEANER_PATH}/ramdisk-cleaner.sh" "${IMG_DIR}/usr/local/bin/rrlogclean.sh"
            install -d "${IMG_DIR}/etc/crontabs"
            echo "*/5 * * * * /usr/local/bin/rrlogclean.sh" >> "${IMG_DIR}/etc/crontabs/root"
        else
            echo "- $RAMCLEANER_PATH/ramdisk-cleaner.sh not found/readable, cannot add rrlogclean.sh in image"
        fi
    fi
}

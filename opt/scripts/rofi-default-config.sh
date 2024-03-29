#!/bin/bash

ROOT_DIR="$XDG_USER_CONFIG_DIR/rofi"

function rebuild_config {
    rm -rf $ROOT_DIR/config*
    rofi -dump-config > $ROOT_DIR/config.rasi
}

function rebuild_theme {
    rm -rf $ROOT_DIR/theme*
    rofi -dump-theme > $ROOT_DIR/theme.rasi
}

function reconnect_theme {
    sed \
        --in-place='.bak' \
        --regexp-extended \
        -e "s~^.*\stheme:.*$~\ttheme: \"~/theme.rasi\";~g" \
        $ROOT_DIR/config.rasi
}

if [[ -n "$1" ]]; then
    INPUT="$1"
else
    INPUT=$(
        echo -e "config\ntheme\nall" \
            | rofi \
                -dmenu \
                -mesg 'forcibly rebuild config' \
                -no-fixed-num-lines \
                -width 24 \
                -hide-scrollbar \
                -theme-str '#inputbar { children: [entry,case-indicator]; }' \
                -theme-str '#listview { dynamic: true; }' \
                -theme-str '#mainbox { children: [message,inputbar,listview]; }' \
                -theme-str '#message { border: 0; background-color: @selected-normal-background; text-color: @selected-normal-foreground; }' \
                -theme-str '#textbox { text-color: inherit; }'
    )
    if [[ -z $INPUT ]]; then
        exit 0
    fi
fi

case "$INPUT" in
    config)
        rebuild_config
        ;;
    theme)
        rebuild_theme
        ;;
    all)
        rebuild_config
        rebuild_theme
        ;;
    *)
        echo "usage: $0 {config,theme,all}"
        exit 1
        ;;
esac
reconnect_theme

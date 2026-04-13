#!/usr/bin/env bash

# Clear Notifications
if command -v dunst > /dev/null 2>&1; then
    dunstctl clear
fi
# Clear Variables
if [[ -n $imageTaken ]]; then
    unset imageTaken
fi
if [[ -n $flamecfg ]]; then
    unset flamecfg
fi
# Flameshot Config
flamecfg=/tmp/extractorFlameCFG.ini
if [[ -f $HOME/.config/flameshot/flameshot.ini ]]; then
    rm $flamecfg
    touch $flamecfg
    cat $HOME/.config/flameshot/flameshot.ini >> $flamecfg
else
    if [[ ! -f $flamecfg ]]; then
        touch $flamecfg
        cat > "$flamecfg" <<'EOF'
[General]
disabledGrimWarning=true
saveAsFileExtension=.png
savePath=/tmp
showDesktopNotification=false
useGrimAdapter=true
EOF
    else
        rm $flamecfg
        touch $flamecfg
        cat > "$flamecfg" <<'EOF'
[General]
disabledGrimWarning=true
saveAsFileExtension=.png
savePath=/tmp
showDesktopNotification=false
useGrimAdapter=true
EOF
    fi
fi
if [[ -f $HOME/.config/flameshot/flameshot.ini ]]; then
    mv $HOME/.config/flameshot/flameshot.ini /tmp/originalFlameshotConfig.ini
    cp /tmp/extractorFlameCFG.ini $HOME/.config/flameshot/flameshot.ini
else
    cp /tmp/extractorFlameCFG.ini $HOME/.config/flameshot/flameshot.ini
fi
# Remove Old Screenshot
if [[ -f /tmp/tesseractImage.png ]]; then
    rm /tmp/tesseractImage.png
fi
# If Flameshot Exists, Screenshot
if command -v flameshot > /dev/null 2>&1; then
    flameshot config --notifications=false
    # If Screenshotting was Unsuccessful, Abort
    if ! flameshot gui --path=/tmp/tesseractImage.png; then
        flameshot config --notifications=true
        notify-send -i $HOME/Pictures/error.png 'Screenshot Error' 'Screenshot Aborted'
        return 1
        exit 1
    fi
    flameshot config --notifications=true
# Else, Try Flameshot in Nix Shell
else
    # If Screenshotting was Unsuccessful, Abort
    if ! nix-shell -p flameshot --run 'flameshot config --notifications=false; flameshot gui --path=/tmp/tesseractImage.png; flameshot config --notifications=true'; then
        notify-send -i $HOME/Pictures/error.png 'Screenshot Error' 'Screenshot Aborted'
        return 1
        exit 1
    fi
fi
# If Screenshot Exists, Extract
if [[ -f /tmp/tesseractImage.png ]]; then
    nix-shell -p tesseract xclip --run 'tesseract /tmp/tesseractImage.png stdout -l eng+deu+fra+spa+ita+por+nld --psm 6 | xclip -selection clipboard' && notify-send -i $HOME/Pictures/yes.png 'Success' 'Copied Image Text to Clipboard' || notify-send -i $HOME/Pictures/error.png 'Error' 'Unable to Extract Text'
# Else, Throw Error
else
    notify-send -i $HOME/Pictures/error.png 'Tesseract Error' 'No Screenshot Image Found'
fi
if [[ -f $HOME/.config/flameshot/flameshot.ini ]]; then
    rm $HOME/.config/flameshot/flameshot.ini
    mv /tmp/originalFlameshotConfig.ini $HOME/.config/flameshot/flameshot.ini
fi

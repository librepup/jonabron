#!/usr/bin/env bash

print_status() {
    dev_info=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev \
        | grep ":connected" \
        | grep -Ev "^(lo|docker|virbr|veth):" \
        | head -n1)
    if [ -z "$dev_info" ]; then
        echo "%{F#f5e8d5}󱚼 %{F#F04535}Disconnected"
    else
        IFS=: read -r dev type state conn <<< "$dev_info"
        case "$type" in
            ethernet)
                ip=$(nmcli -g IP4.ADDRESS device show "$dev" \
                    | cut -d/ -f1 \
                    | head -n1)
                echo "󰈀 %{F#fed2d8}$ip"
                ;;
            wifi)
                ip=$(nmcli -g IP4.ADDRESS device show "$dev" \
                    | cut -d/ -f1 \
                    | head -n1)
                echo "󰖩 %{F#fed2d8}$ip"
                ;;
            *)
                echo "󱚼 %{F#fed2d8}Disconnected"
                ;;
        esac
    fi
}

print_status

nmcli monitor | while read -r _; do
    print_status
done

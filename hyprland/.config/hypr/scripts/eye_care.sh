#!/bin/bash

sleep 10

while true; do
    # Ждем 1 час (3600 секунд)
    sleep 3600

    if ! pgrep -x "hyprlock" > /dev/null; then
        notify-send "Глаза!" "Посмотри в окно 20 секунд. Капни Hylo Comod!" \
            -i accessories-calculator \
            -u critical \
            -h string:x-canonical-private-synchronous:eye-notification
    fi
done
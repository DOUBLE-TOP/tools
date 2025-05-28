#!/bin/bash

FILE="/etc/logrotate.d/rsyslog"
LOGS="/var/log/syslog
/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/debug
/var/log/messages"

CONFIG="{
	hourly
	rotate 4
	size 100M
	missingok
	notifempty
	compress
	delaycompress
	sharedscripts
	postrotate
		/usr/lib/rsyslog/rsyslog-rotate
	endscript
}
"

# Build the logrotate entry
build_entry() {
	echo "$LOGS"
	echo "$CONFIG"
}

if [ -f "$FILE" ]; then
	echo "Меняю настройки файла: $FILE"

	# Backup original file
	cp "$FILE" "$FILE.bak"

	# Rebuild with new settings
	build_entry > "$FILE"
	echo "Обновлен $FILE с настройками: daily, rotate 4, size 100M."
else
	echo "Создаю файл: $FILE..."
	build_entry > "$FILE"
	echo "Создан $FILE с настройками: daily, rotate 4, size 100M."
fi

sudo cp /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
sudo chmod +x /etc/cron.hourly/logrotate

echo "Запускаем logrotate"
sudo logrotate -f /etc/logrotate.conf

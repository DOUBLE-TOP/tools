#!/bin/bash

HOURLY_CONF_DIR="/etc/logrotate.hourly"
CONF_FILE="$HOURLY_CONF_DIR/rsyslog"
STATE_FILE="/var/lib/logrotate/logrotate.hourly.status"
CRON_SCRIPT="/etc/cron.hourly/logrotate-hourly"

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
	su root syslog
	postrotate
		/usr/lib/rsyslog/rsyslog-rotate
	endscript
}
"

# Create hourly config directory if it doesn't exist
sudo mkdir -p "$HOURLY_CONF_DIR"

# Write the rsyslog hourly logrotate config
echo "Создаю файл настроек: $CONF_FILE"
{
	echo "$LOGS"
	echo "$CONFIG"
} | sudo tee "$CONF_FILE" > /dev/null

# Remove the daily version to avoid double rotation
if [ -f /etc/logrotate.d/rsyslog ]; then
	echo "Удаляю ежедневный файл: /etc/logrotate.d/rsyslog"
	sudo rm /etc/logrotate.d/rsyslog
fi

# Create the hourly cron job
echo "Создаю cron-скрипт: $CRON_SCRIPT"
sudo tee "$CRON_SCRIPT" > /dev/null <<EOF
#!/bin/bash
/usr/sbin/logrotate -s $STATE_FILE $CONF_FILE
EOF

# Make it executable
sudo chmod +x "$CRON_SCRIPT"

# Test run
echo "Тестовый запуск logrotate"
sudo "$CRON_SCRIPT"

echo "Готово. Логи будут ротироваться каждый час."

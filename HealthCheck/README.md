Features:

- Shows Non Temporary File System Usage
- Shows Memory Usage
- Shows total CPU Usage
- Shows top 5 processes by CPU usage

The script is currently setup to run every hour and outputs to '/var/log/health_check/health_check.log'
	
This was achieved via a cron job:

`crontab -e`
`0 * * * * /home/benbo/dev/scripts/HealthCheck/health_check.sh >> /var/log/health_check.log 2>&1`

Then a daily log rotation was setup using logrotate:

`sudo nano /etc/logrotate.d/health_check`

```
/var/log/health_check.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
}
```

this creates a new log file each day, keeps 7 days of logs, compresses old ones and runs automatically


# Linux System Monitoring Script

## Project Overview

The Linux System Monitoring Script is a Bash-based
system administration tool developed on Red Hat
Enterprise Linux 10.

It monitors important system resources and displays
their usage through a continuously refreshing
terminal dashboard.

## Features

- CPU utilization monitoring
- RAM usage monitoring
- Disk space monitoring
- Network traffic monitoring
- System hostname and uptime information
- Resource usage warning alerts
- Automatic monitoring log generation
- Dashboard refresh every 5 seconds

## Technologies Used

- Red Hat Enterprise Linux 10
- Bash Shell Scripting
- Linux Command Line
- AWK
- Linux /proc filesystem

## System Requirements

- Linux operating system
- Bash shell
- Standard Linux utilities: awk, free, df, top
- Root or suitable permissions for project files

## Project Structure

```text
linux-system-monitor/
├── monitor.sh
├── monitor.log
├── README.md
└── .gitignore
```

## Installation

Clone the repository:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate to the project:

```bash
cd linux-system-monitor
```

Give execution permission:

```bash
chmod +x monitor.sh
```

## Execution

Run the monitoring script:

```bash
./monitor.sh
```

Press CTRL+C to stop monitoring.

## Alert Thresholds

The script displays warning messages when:

- CPU usage reaches 80%
- Memory usage reaches 80%
- Disk usage reaches 80%

## Logging

Monitoring information is automatically
recorded in monitor.log.

## Learning Outcomes

- Practical Linux system administration
- Bash scripting and automation
- CPU, memory and disk monitoring
- Network statistics collection
- Linux process and resource management
- System logging and troubleshooting

## Author

Krishna Kansara

Linux System Administration Project


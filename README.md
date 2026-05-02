# ForensiCollect

ForensiCollect is a modular Linux DFIR (Digital Forensics and Incident Response) triage tool designed to rapidly collect system artifacts, analyze authentication activity, detect persistence mechanisms, generate structured forensic outputs, and assess overall system risk.

This project demonstrates practical incident response workflows and hands-on experience with Linux system analysis, log parsing, and forensic data collection.

---

## Overview

ForensiCollect performs automated triage of a Linux system by collecting key artifacts and analyzing them to identify potential indicators of compromise. The tool produces both human-readable and structured outputs to support investigation, reporting, and further analysis.

---

## Features

### System and Artifact Collection
- System information (OS, hostname, uptime)
- User accounts and privilege enumeration
- Running processes and process trees
- Network configuration, listening ports, and active connections
- Services (running, enabled, failed)
- Scheduled tasks (cron jobs)
- Recently modified files
- Persistence-related locations

### Authentication and Log Analysis
- Parses `/var/log/auth.log` or `/var/log/secure`
- Detects:
  - Failed SSH login attempts
  - Successful SSH logins
  - Root login activity
  - New user creation events
  - Sudo and privilege escalation activity
  - `su` command usage

### Structured Output
- Human-readable reports (`.txt`)
- Structured data (`.csv`)
- Timeline-ready event data
- Evidence hash manifest using SHA-256

### Risk Scoring
The tool evaluates system activity using weighted indicators, including:
- Excessive failed login attempts
- Root SSH access
- New user creation
- Privilege escalation activity
- Multiple UID 0 accounts
- Suspicious network ports
- Elevated cron activity

Output includes:
- Risk Score (0–100)
- Risk Level (LOW, MEDIUM, HIGH)

### Persistence Detection
Checks common Linux persistence mechanisms:
- Cron jobs (`/etc/crontab`, `/etc/cron.*`, user crontabs)
- SSH authorized keys
- Systemd service files
- `/etc/rc.local`
- Shell startup files
- SUID binaries

### Evidence Packaging
- Creates timestamped case directories
- Generates SHA-256 hash manifest for collected files
- Packages results into a compressed archive (`.tar.gz`)
- Generates hash for archive verification

### Command-Line Options

```bash
sudo ./forensicollect.sh --full
sudo ./forensicollect.sh --quick
sudo ./forensicollect.sh --auth-only
sudo ./forensicollect.sh --no-archive
sudo ./forensicollect.sh --help

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

The tool supports multiple execution modes to control the depth of analysis:

- --full  
  Runs full system triage including all modules, risk scoring, and evidence packaging.

- --quick  
  Runs a reduced set of modules for faster analysis, including authentication, users, processes, and network data.

- --auth-only  
  Runs only authentication log parsing and risk evaluation.

- --no-archive  
  Skips creation of the compressed case archive.

- --help  
  Displays usage information and available options.

### Example Usage

sudo ./forensicollect.sh --full

## Project Structure

forensicollect/
├── forensicollect.sh          # Main execution script
├── modules/                   # Modular DFIR components
│   ├── auth_parser.sh         # Authentication log analysis
│   ├── users.sh               # User and privilege enumeration
│   ├── processes.sh           # Process collection and analysis
│   ├── network.sh             # Network configuration and connections
│   ├── cron.sh                # Scheduled task collection
│   ├── services.sh            # Service enumeration
│   ├── files.sh               # Recently modified files
│   ├── persistence.sh         # Persistence mechanism detection
│   ├── risk_score.sh          # Risk evaluation logic
│   └── package_case.sh        # Evidence packaging
├── output/                    # Generated case data
│   └── .gitkeep
├── .gitignore
├── LICENSE
└── README.md

## Installation

Clone the repository and set execution permissions:

git clone https://github.com/eaande/forensicollect.git
cd forensicollect
chmod +x forensicollect.sh modules/*.sh

## Usage

Run a full system triage:

sudo ./forensicollect.sh --full

For faster analysis:

sudo ./forensicollect.sh --quick

For authentication-only analysis:

sudo ./forensicollect.sh --auth-only

## Output

Each execution creates a timestamped case directory in the output folder:

output/case_YYYYMMDD_HHMMSS/

Example contents include:

system_info.txt           # Basic system information
users.txt                 # User accounts and privilege data
processes.txt             # Running processes and process tree
network.txt               # Network configuration and connections
network_connections.csv   # Structured network connection data
cron.txt                  # Scheduled tasks and cron jobs
services.txt              # Service information
recent_files.txt          # Recently modified files
recent_files.csv          # Structured file change data
persistence_checks.txt    # Persistence-related findings
auth_events.txt           # Parsed authentication events
auth_events.csv           # Structured authentication data
risk_report.txt           # Risk score and analysis
hash_manifest.txt         # SHA-256 hashes of collected files
collection_log.txt        # Execution log
case_YYYYMMDD_HHMMSS.tar.gz   # Compressed case archive

## Skills Demonstrated

- Linux system administration and command-line proficiency
- Bash scripting and modular tool development
- Digital forensics and incident response (DFIR) workflows
- Authentication log analysis and event parsing
- Persistence detection techniques on Linux systems
- Risk-based security analysis and scoring
- Data structuring using CSV outputs
- Evidence integrity using SHA-256 hashing
- Secure and organized GitHub project development

## Real-World Application

ForensiCollect simulates the initial phase of incident response, where analysts must quickly collect and analyze system data to identify potential security incidents.

The tool supports workflows such as:

- Rapid triage of potentially compromised Linux systems
- Identification of suspicious authentication activity
- Detection of persistence mechanisms used by attackers
- Prioritization of investigation based on risk indicators
- Preparation of collected evidence for further forensic analysis

This approach reflects real-world DFIR practices where speed, accuracy, and structured data collection are critical during the early stages of an investigation.

## Disclaimer

This tool is intended for educational purposes and authorized security analysis only. Do not use this tool on systems without explicit permission.

---

## License

This project is licensed under the MIT License.

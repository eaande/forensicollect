# ForensiCollect

ForensiCollect is a lightweight Linux DFIR triage tool designed to collect key system artifacts, parse authentication logs, generate investigation timelines, flag high-risk events, and produce a concise forensic summary.

This project was built to strengthen hands-on skills in Linux security, incident response, log analysis, and digital forensics.

## Features

- Collects basic Linux system information
- Parses `/var/log/auth.log`
- Detects failed SSH login attempts
- Detects successful SSH logins
- Flags root SSH logins
- Identifies sudo / privilege escalation activity
- Generates a forensic timeline
- Creates a high-risk event report
- Produces an investigation summary
- Generates SHA-256 hashes for collected evidence

## Project Structure

```text
forensicollect/
├── forensicollect.sh
├── modules/
│   ├── auth_parser.sh
│   ├── risk_flags.sh
│   ├── timeline.sh
│   └── summary.sh
├── output/
│   └── .gitkeep
├── .gitignore
├── LICENSE
└── README.md

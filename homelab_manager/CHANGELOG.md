## 0.4.1

- Hub Homelab Manager 0.4.1

## 0.4.0

- Hub Homelab Manager 0.4.0

## 0.3.46

- Hub Homelab Manager 0.3.46

## 0.3.39

- Hub Homelab Manager 0.3.39

# Changelog

## 0.3.38

- Ship Homelab Manager 0.3.38, which reads `reset_superadmin_password` (ignored by the 0.3.37 hub).
- Filter MongoDB info-level lines out of the log when `verbose_logs` is off (`--quiet` alone keeps them).

## 0.3.37-3

- Add a configuration option to reset the superadmin password on startup.
- Add a `verbose_logs` option (off by default): hub logs at `warn` and MongoDB `--quiet` unless enabled.

## 0.3.37-2

- Add the MongoDB service account required by the official MongoDB binary.

## 0.3.37-1

- Package MongoDB from the official multi-architecture image so the app also builds for ARM64.

## 0.3.37

- Hub Homelab Manager 0.3.37.

## 0.3.36

- Première version de l'application Homelab Manager autonome pour Home Assistant OS.

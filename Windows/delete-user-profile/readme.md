# 🧹 Bulk User Profile Cleanup Script (PowerShell)

[![PowerShell](https://img.shields.io/badge/Language-PowerShell-5391FF?style=flat-square&logo=powershell)](https://github.com/microsoft/PowerShell)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-Yes-green.svg?style=flat-square)](https://github.com/yourusername/yourrepo)

A simple yet powerful PowerShell script designed to reclaim disk space on Windows machines by automatically deleting local user profiles that have been inactive for a specified period.

---

## ✨ Features

* **Timed Cleanup:** Automatically deletes profiles untouched for the last **30 days** (configurable via the `$days` variable).
* **Safety First:** Skips system-critical, active, and explicitly excluded administrative profiles (`*Administrator*`, `*aicadmin*`).
* **Targeted:** Only targets profiles located under the standard `C:\Users\` path.
* **Logging:** Detailed logging of all actions (success or failure) to a centralized log file (`C:\CleanupLog.txt`).

## 🛠️ Prerequisites

* A Windows operating system (Client or Server).
* **Administrator privileges** are required to run the script and delete profiles.
* PowerShell 5.1 or newer.

## 🚀 How to Use

1.  **Download:** Save the script as `delete_userprofile.ps1` in a convenient location (e.g., your local scripts folder).
2.  **Execution:** Run the script from an elevated PowerShell session (Run as Administrator):

    ```powershell
    .\delete_userprofile.ps1
    ```

3.  **Review Log:** Check the log file at `C:\CleanupLog.txt` for a summary of deleted and skipped profiles.

    ```powershell
    # Review the last 10 log entries after execution
    Get-Content C:\CleanupLog.txt -Tail 10
    ```

---

## ⚙️ Configuration

You can easily adjust the cleanup parameters by modifying the top section of the `delete_userprofile.ps1` script:

| Variable | Default Value | Description |
| :--- | :--- | :--- |
| **`$days`** | `30` | The minimum number of days since the last use time for a profile to be considered for deletion. Change this value for a longer or shorter retention period. |
| **`$logFile`** | `"C:\CleanupLog.txt"` | The path where the script output and errors are logged. |

### Exclusion Logic

The script uses `Where-Object` to define which profiles are *excluded* from deletion. By default, it skips:

1.  System-defined accounts (`$_.Special -eq $false` ensures this).
2.  Profiles containing the string `*Administrator*`.
3.  Profiles containing the string `*aicadmin*`.

To exclude additional accounts (e.g., a service account named `*svc-backup*`), simply add another `-notlike` condition to the `Where-Object` block in the script.

## ⚠️ Important Security & Usage Note

This script performs a permanent deletion of the user profile folder and registry keys using `Remove-CimInstance`.

**Always:**

* Test the script in a non-production or virtual environment first.

* Ensure that the `$days` threshold and the explicit exclusions (`*Administrator*`, `*aicadmin*`) are appropriate for your environment's needs.

* The script is designed to **not delete the currently logged-in profile**, but it requires Administrator rights to execute.

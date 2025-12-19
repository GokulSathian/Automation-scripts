# 🔑 Bulk AD Password Reset Tool (PowerShell)

[![PowerShell](https://img.shields.io/badge/Language-PowerShell-5391FF?style=flat-square&logo=powershell)](https://github.com/microsoft/PowerShell)
[![ADDS](https://img.shields.io/badge/Service-Active%20Directory-blue?style=flat-square)](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-domain-services)

A specialized PowerShell script for bulk password resets in Active Directory. It identifies users based on an **Employee ID** (stored in the `mobile` attribute) provided in an input text file and applies a new password.

---

## ✨ Features

* **Attribute-Based Matching:** Searches for users where the `mobile` attribute matches the provided Employee ID.
* **Security Validation:** Automatically skips disabled accounts to prevent security policy violations.
* **Secure Handling:** Converts plain-text password input into a `SecureString` for the reset process.
* **Auto-Reporting:** * Generates a **CSV report** of all successful resets.
    * Generates a **Missing Log** for IDs that could not be found in AD.
* **Automated Cleanup:** Refreshes the log directory on every run to ensure data accuracy.

## 🛠️ Prerequisites

* **RSAT Tools:** Must have the `Active Directory` PowerShell module installed.
* **Permissions:** Account running the script must have permissions to reset passwords in the target OUs.
* **Data Mapping:** This script assumes the **Employee ID** is stored in the user's `mobile` field in AD.

## 🚀 How to Use

1. **Prepare Input:** Create a `.txt` file with one Employee ID per line.
2. **Run Script:** Open PowerShell as Administrator and execute:

   ```powershell
   .\Reset-Passwords.ps1 -InputFile "C:\path\to\ids.txt" -password "NewSecretPass123!"
   
3. **Optional Parameters:**
   * `-LogDir`: Specify a custom path for logs (Default: `C:\temp\AD-resets`).

---

## 📂 Output & Logging

The script creates a dedicated folder for transparency and auditing:

| File | Content |
| :--- | :--- |
| **`Reset_AccountInfo.csv`** | Contains EmployeeID, Name, and SAMAccountName for successful resets. |
| **`Missing_Empid.log`** | Lists all IDs from the input file that did not match any AD user. |

---

## 💾 The Script Structure

```powershell
**Rquired Parameters:**
# -InputFile : Path to text file with IDs
# -password  : The temporary password to assign
# -LogDir    : (Optional) Path for results.
```

## ⚠️ Important Security & Usage Note

* **Policy Awareness:** This script sets `ChangePasswordAtLogon` to `$false`. If your company policy requires a change at next login, you may need to adjust the script logic.
* **Attribute Mapping:** Ensure your organization actually uses the `mobile` field for Employee IDs before running in production.
* **Logging:** Be aware that the log directory is **deleted and recreated** every time the script runs; back up previous logs if needed.
* **Plain Text Warning:** Be cautious when passing passwords as plain text in the command line, as they may be visible in PowerShell history (`Get-History`).



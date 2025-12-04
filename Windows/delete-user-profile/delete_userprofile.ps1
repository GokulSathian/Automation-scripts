# ===========================
# delete_userprofile.ps1
# ===========================

# Number of days since last use
$days = 30
$logFile = "C:\CleanupLog.txt"

# Get all user profiles except system and excluded accounts
$profiles = Get-CimInstance Win32_UserProfile | Where-Object {
    $_.Special -eq $false -and
    $_.LocalPath -like 'C:\Users\*' -and
    $_.LocalPath -notlike '*Administrator*' -and
    $_.LocalPath -notlike '*aicadmin*' -and
    $_.LastUseTime -lt (Get-Date).AddDays(-$days)
}

foreach ($profile in $profiles) {
    try {
        Write-Host "Deleting profile: $($profile.LocalPath)"
        Remove-CimInstance -InputObject $profile
        "Deleted: $($profile.LocalPath) at $(Get-Date)" | Out-File $logFile -Append
    }
    catch {
        "Failed to delete: $($profile.LocalPath) - $_" | Out-File $logFile -Append
    }
}

param(
[Parameter(Mandatory)]
[string]$InputFile,

[Parameter(Mandatory)]
[string]$password,

[string]$LogDir = "C:\temp\AD-resets"
)
$MissingLog = "$LogDir\Missing_Empid.log"
$SuccessLog = "$LogDir\Reset_AccountInfo.csv"

if (Test-Path $LogDir){
	Remove-Item -Path $LogDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

$securePass = ConvertTo-SecureString -String $password -AsPlainText -Force
$result =[System.Collections.Generic.List[PSCustomObject]]::new()

Get-Content $InputFile | ForEach-Object {
	$empid = $_.Trim()
	If($empid){
		$adUser = Get-ADUser -Filter "mobile -eq '$empid'"
		if($adUser){
			if($adUser.Enabled) {
				$adUser | Set-ADAccountPassword -NewPassword $securePass -Reset
				$adUser | Set-ADUser -ChangePasswordAtLogon $false
				$result.add([PSCustomObject]@{
					EmployeeID =$empid
					Name = $adUser.Name
					UserName = $adUser.SamAccountName
				})
				Write-Host "Success: Password reset for EmployeeID $($adUser.Name)" -ForegroundColor Green
			}
			else {
				Write-Host "Skipped: User $adUser.name $adUser.SamAccountName is Disabled." -ForegroundColor Yellow
			}
		}
		else {
			Add-Content -Path $MissingLog -Value "Employee ID Not Found $empid"
			Write-Host "Error: No user Found check log $MissingLog" -ForegroundColor Red
		}
	}
	
}

if ($result.Count -gt 0) {
    $result | Export-Csv -Path $SuccessLog -NoTypeInformation
    Write-Host "`nResults saved to: $SuccessLog" -ForegroundColor Cyan
}



# Antigravity Project Colorizer
# Logic: Generates a stable hex color from the folder name and applies it to VS Code via the Peacock extension settings.

$name = (Get-Item .).Name
$hash = [Math]::Abs($name.GetHashCode())

# To keep the "Antigravity Aesthetic" (vibrant and sleek), we limit colors to a specific range
# Skip very dark or very light colors to ensure readability
$color = "#" + ($hash.ToString("X6")).Substring(0, 6)

Write-Host "🎨 Colorizing AntiGravity Project: $name -> $color" -ForegroundColor Green

# Ensure .vscode exists
if (!(Test-Path ".vscode")) {
    New-Item -ItemType Directory -Path -Force ".vscode" | Out-Null
}

$settingsPath = ".vscode/settings.json"
$settings = if (Test-Path $settingsPath) {
    Get-Content $settingsPath | ConvertFrom-Json
} else {
    New-Object PSObject
}

# Add or Update Peacock settings correctly using PowerShell assignment
$settings | Add-Member -MemberType NoteProperty -Name "peacock.color" -Value $color -Force

# Save back to file
$settings | ConvertTo-Json -Depth 20 | Set-Content $settingsPath

Write-Host "✅ VS Code Workspace Colorized! (Restart VS Code if colors don't update immediately)" -ForegroundColor Cyan

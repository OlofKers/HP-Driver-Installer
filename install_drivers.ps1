# ================================
# HP Driver Installer
# ================================
# TODO: Configure these paths for your environment
$HPIA = "C:\path\to\HPImageAssistant.exe"  # Update this to your HPIA executable path
$Drivers = "C:\path\to\Drivers"            # Update this to your Drivers folder path
$ReportPath = "C:\path\to\Reports"         # Update this to your Reports folder path

Write-Host "Testing Path..."
if(-Not (Test-Path $HPIA)) {
    Write-Host "HPIA executable not found at: $HPIA" -ForegroundColor Red
    exit
}
if(-Not (Test-Path $Drivers)) {
    Write-Host "Creating Drivers folder at: $Drivers"
    New-Item -ItemType Directory -Path $Drivers -Force | Out-Null
}
if(-Not (Test-Path $ReportPath)) {
    Write-Host "Creating Reports folder at: $ReportPath"
    New-Item -ItemType Directory -Path $ReportPath -Force | Out-Null
}

Write-Host "Starting HP Driver Installation..." -ForegroundColor Cyan

# Run Install
$installProcess = Start-Process -FilePath $HPIA -ArgumentList @(
    "/Operation:Analyze",
    "/Action:Install",
    "/Category:All",
    "/Selection:All",
    "/SoftpaqDownloadFolder:`"$Drivers`"",
    "/Silent"
) -Wait -PassThru

Write-Host "Install process exit code: $($installProcess.ExitCode)" -ForegroundColor Yellow

Write-Host "`nInstallation Complete. Verifying..." -ForegroundColor Yellow

# Run Verification
$verifyProcess = Start-Process -FilePath $HPIA -ArgumentList @(
    "/Operation:Analyze",
    "/Category:All",
    "/ReportFolder:`"$ReportPath`"",
    "/Silent"
) -Wait -PassThru

Write-Host "Verify process exit code: $($verifyProcess.ExitCode)" -ForegroundColor Yellow

# Check if report exists
if (-Not (Test-Path $ReportPath)) {
    Write-Host "Report path does not exist: $ReportPath" -ForegroundColor Red
} else {
    Write-Host "Report path exists. Checking for files..." -ForegroundColor Yellow
    $allFiles = Get-ChildItem $ReportPath -Recurse
    if ($allFiles) {
        Write-Host "Files found in $ReportPath`:" -ForegroundColor Yellow
        $allFiles | ForEach-Object { Write-Host "  - $($_.FullName)" }
    } else {
        Write-Host "No files found in Report path" -ForegroundColor Red
    }
    
    $LatestReport = Get-ChildItem $ReportPath | Where-Object { $_.Extension -eq '.html' -or $_.Extension -eq '.json' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

if ($LatestReport -and ($LatestReport.LastWriteTime -gt (Get-Date).AddMinutes(-5))) {
    Write-Host "Report generated, check to see changes: $($LatestReport.FullName)" -ForegroundColor Green
} else {
    Write-Host "No report found, something went wrong..." -ForegroundColor Red
}

Write-Host "done"
Pause
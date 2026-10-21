$folder = "C:\Users\hch\OneDrive\Vejrkamera snapshots"
$filter = "Weathercam_snapshotScene.png"

Set-Location $folder

# Ryd op i tidligere overvågninger i baggrunden
Get-EventSubscriber -ErrorAction SilentlyContinue | Unregister-Event

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folder
$watcher.Filter = $filter
$watcher.EnableRaisingEvents = $true

$action = {
    param($sender, $e)
    Start-Sleep -Seconds 3
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Billede opdateret! Uploader til GitHub..." -ForegroundColor Yellow
    
    git add Weathercam_snapshotScene.png
    git commit -m "Auto update weathercam"
    git push origin main
    
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Upload fuldført!" -ForegroundColor Green
}

Register-ObjectEvent $watcher "Changed" -Action $action

Write-Host "Overvåger KUN $filter. Venter på næste OBS snapshot..." -ForegroundColor Cyan
while ($true) { Start-Sleep -Seconds 5 }
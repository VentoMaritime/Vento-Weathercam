$folder = "C:\Users\hch\OneDrive\Vejrkamera snapshots"
Set-Location $folder

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folder
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$action = {
    param($sender, $e)
    $filename = $e.Name
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Registrerede ændring på fil: $filename" -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2
    git add .
    git commit -m "Auto update weathercam"
    git push origin main
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Push udført for $filename!" -ForegroundColor Green
}

# Ryd op i gamle overvågninger før opstart
Get-EventSubscriber -ErrorAction SilentlyContinue | Unregister-Event
Register-ObjectEvent $watcher "Changed" -Action $action
Register-ObjectEvent $watcher "Created" -Action $action

Write-Host "Overvågning NULSTILLET og kører på ALLERENDE filer i mappen..." -ForegroundColor Cyan
while ($true) { Start-Sleep -Seconds 2 }
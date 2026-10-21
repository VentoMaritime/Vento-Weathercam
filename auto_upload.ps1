$folder = "C:\Users\hch\OneDrive\Vejrkamera snapshots"
$targetFile = "Weathercam_snapshotScene.png"
$fullPath = Join-Path $folder $targetFile

Set-Location $folder

$lastWrite = (Get-Item $fullPath -ErrorAction SilentlyContinue).LastWriteTime

Write-Host "Overvåger $targetFile via direkte tjek..." -ForegroundColor Cyan

while ($true) {
    if (Test-Path $fullPath) {
        $currentWrite = (Get-Item $fullPath).LastWriteTime
        
        if ($null -ne $lastWrite -and $currentWrite -gt $lastWrite) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Billede opdateret! Henter seneste GitHub-status og uploader..." -ForegroundColor Yellow
            
            Start-Sleep -Seconds 2
            git add Weathercam_snapshotScene.png
            git commit -m "Auto update weathercam"
            git pull origin main --rebase
            git push origin main
            
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Upload fuldført til GitHub!" -ForegroundColor Green
            $lastWrite = $currentWrite
        } elseif ($null -eq $lastWrite) {
            $lastWrite = $currentWrite
        }
    }
    
    Start-Sleep -Seconds 5
}
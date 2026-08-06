$file = "C:\Users\USER\Desktop\統森吊車2026.html"
$repo = "C:\Users\USER\tungshen"
$debounce = $false

# ── 監控本機存檔 → 推到 GitHub ──
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = Split-Path $file
$watcher.Filter = Split-Path $file -Leaf
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

$pushAction = {
    if ($Event.MessageData) { return }
    $Event.MessageData = $true
    Start-Sleep -Seconds 3
    Copy-Item $using:file "$using:repo\統森吊車2026.html" -Force
    Copy-Item $using:file "$using:repo\index.html" -Force
    Set-Location $using:repo
    git add -A 2>$null
    $msg = "auto sync " + (Get-Date -Format "yyyy-MM-dd HH:mm")
    git commit -m $msg 2>$null
    git push origin main 2>$null
    $Event.MessageData = $false
}

Register-ObjectEvent $watcher Changed -Action {
    Start-Sleep -Seconds 3
    Copy-Item "C:\Users\USER\Desktop\統森吊車2026.html" "C:\Users\USER\tungshen\統森吊車2026.html" -Force
    Copy-Item "C:\Users\USER\Desktop\統森吊車2026.html" "C:\Users\USER\tungshen\index.html" -Force
    Set-Location "C:\Users\USER\tungshen"
    git add -A 2>$null
    git commit -m ("auto sync " + (Get-Date -Format "yyyy-MM-dd HH:mm")) 2>$null
    git push origin main 2>$null
} | Out-Null

# ── 每 2 分鐘從 GitHub 拉取，有更新就複製到桌面 ──
while ($true) {
    Start-Sleep -Seconds 120

    Set-Location $repo
    $before = git rev-parse HEAD 2>$null
    git pull origin main --quiet 2>$null
    $after = git rev-parse HEAD 2>$null

    if ($before -ne $after) {
        # 有新版本，複製到桌面（先備份舊檔）
        $backup = "C:\Users\USER\Desktop\統森吊車2026_backup_" + (Get-Date -Format "yyyyMMdd_HHmm") + ".html"
        Copy-Item $file $backup -Force -ErrorAction SilentlyContinue
        Copy-Item "$repo\統森吊車2026.html" $file -Force
    }
}

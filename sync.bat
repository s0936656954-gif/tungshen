@echo off
chcp 65001 >nul
echo 正在同步到 GitHub...
copy /Y "C:\Users\USER\Desktop\統森吊車2026.html" "C:\Users\USER\tungshen\統森吊車2026.html" >nul
copy /Y "C:\Users\USER\Desktop\統森吊車2026.html" "C:\Users\USER\tungshen\index.html" >nul
cd /d "C:\Users\USER\tungshen"
git add -A
git commit -m "sync %date% %time%"
git push origin main
echo.
echo 同步完成！網頁版約 1-2 分鐘後更新。
pause

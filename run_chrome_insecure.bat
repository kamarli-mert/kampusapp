@echo off
echo Chrome guvenliksiz modda aciliyor...
echo Lutfen tum Chrome pencerelerini kapattiginizdan emin olun.
start chrome.exe --user-data-dir="C:/ChromeDev" --disable-web-security
echo Chrome acildi. Flutter uygulamanizin adresini (ornek: http://localhost:12345) bu yeni pencereye kopyalayin.
pause

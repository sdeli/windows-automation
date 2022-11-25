@echo off

vdesk on:2 run:"C:\Users\bgfks\AppData\Local\Programs\Microsoft VS Code\Code.exe"

TIMEOUT /T 2
vdesk on:3 run:"\Program Files (x86)\Google\Chrome\Application\chrome" /new-window https://www.google.com

TIMEOUT /T 2
vdesk on:1 run:"\Program Files (x86)\Google\Chrome\Application\chrome" /new-window https://nodejs.org/dist/latest-v12.x/docs/api/

exit
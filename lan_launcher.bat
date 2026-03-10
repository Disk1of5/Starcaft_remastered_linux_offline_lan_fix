@echo off
:: 1. Launch the main StarCraft game client first
:: Using 'start' ensures the batch script continues to the next line
start "" "StarCraft.exe" -launch

:: 2. Wait for the game to fully initialize (4 seconds is safest)
:: This gives the prefix time to spin up and the game to reach the menu
timeout /t 4 /nobreak > nul

:: 3. Now launch the 64-bit discovery service
:: This should now 'see' the active game environment
start "" "ClientSdkMDNSHost.exe"

exit

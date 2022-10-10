$desktop = "C:\Users\Public\Desktop"
$sim = "D:\Games\RBR"
$antifa = "D:\Games\RBR\Antifa"

$scs = @( "RallySimFans_Launcher.lnk" )
$bins = @( "Rallysimfans_Installer.exe", "Rallysimfans_NGP_Switcher.exe", "rsf_launcher\RSF_Launcher.exe" )
$ico = "$antifa\rallysimfans.ico"

foreach ($sc in $scs) {
	$sf = "$desktop\$sc"
	$WScriptShell = New-Object -ComObject WScript.Shell
	$shortcut = $WScriptShell.CreateShortcut($sf)
	echo "Setting $ico as icon for $sfq..."
	$shortcut.IconLocation = $ico
	$shortcut.Save()
}

echo "Removing useless ""Rallysimfans RBR.lnk""..."
rm "$desktop\Rallysimfans RBR.lnk"

foreach ($bin in $bins) {
	$bf = "$sim\$bin"
	echo "Setting $ico as icon for $bf..."
	& ".\rcedit-x64.exe" "$bf" --set-icon "$ico" 
}

echo "Deflagging HUD..."
Copy-Item -Force -Path "$antifa\Generic\*" -Destination "$sim\Generic" -Recurse
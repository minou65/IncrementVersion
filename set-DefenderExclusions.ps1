# Prozesse von Microsoft Defender ausschließen
Add-MpPreference -ExclusionProcess "devenv.exe"
Add-MpPreference -ExclusionProcess "vmicro.exe"
Add-MpPreference -ExclusionProcess "xtensa-esp32-elf-gcc.exe"
Add-MpPreference -ExclusionProcess "esptool.exe"
Add-MpPreference -ExclusionProcess "python.exe"
Add-MpPreference -ExclusionProcess "cmake.exe"
Add-MpPreference -ExclusionProcess "ninja.exe"

# Ordner von Microsoft Defender ausschließen
Add-MpPreference -ExclusionPath "C:\Users\andy\AppData\Local\Arduino15"
Add-MpPreference -ExclusionPath "C:\Users\andy\AppData\Local\VisualMicro"
Add-MpPreference -ExclusionPath "C:\Users\andy\AppData\Local\Temp\VMBuilds"
Remove-MpPreference -ExclusionPath "C:\Users\andy\AppData\Local\Temp"
Add-MpPreference -ExclusionPath "C:\Users\andy\.espressif"
Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Arduino"
Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft Visual Studio"

# Dateierweiterungen von Microsoft Defender ausschließen
Add-MpPreference -ExclusionExtension "bin"
Add-MpPreference -ExclusionExtension "cpp"
Add-MpPreference -ExclusionExtension "elf"
Add-MpPreference -ExclusionExtension "h"
Add-MpPreference -ExclusionExtension "hex"
Add-MpPreference -ExclusionExtension "hpp"
Add-MpPreference -ExclusionExtension "vmpreproc"

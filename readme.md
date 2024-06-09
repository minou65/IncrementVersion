#Increment Version

In Visual Studio  vMicro \ Add Code \ Add local board.txt ausführen
In der neu erstelleten Datei folgenden Code hinzufügen
```
# Increment version before build
recipe.hooks.sketch.prebuild.0.pattern=powershell.exe "P:\Andy\Repos\InkrementVersion\increment.ps1" {build.path} {build.source.path} {build.project_name}
```

Eine Datei version.h dem Projekt mit folgendem Inhalt hinzufügen
```
#define VERSION "1.0.0.0"
```

Folgenden Code kann verwendet werden um die Version anzuzeigen
```c++
#include "version.h"

// Manufacturer's Software version code
char Version[] = VERSION;

void setup(){
    Serial.begin(115200);
    while (!Serial) {
        delay(1);
    }
    Serial.printf("Firmware version:%s\n", Version);
}
```
Bei jedem erfolgreichen Build wird die Buildversion nun automatisch erhöht

Mehr zur Seamtic Versionierung
https://semver.org/lang/de/


{build.project_path}
{vm.last.buildpath}
{build.project_name}
{menu.fsupload.littlefs.runtime.tools.mklittlefs.path}


https://www.visualmicro.com/forums/YaBB.pl?num=1659257178/4

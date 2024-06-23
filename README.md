# TouchpadMouse_forMSX0
MSX0用タッチパッドマウスドライバ

MSX0には標準で画面タッチによるタッチパッド機能が備わっています。  
ただ画面が小さく、画面上に配置したUIをタッチするのに指で隠れて的に当たっているかわかりずらいと感じていました。  
そこで、最近のPCではおなじみのタッチパッドによるマウス操作を実現できないかと思い、ドライバを組みました。

本ドライバはマシン語で作成しています。  
標準では&HC000に配置され、USR関数により各種値が取れるようになっています。  
以下、各呼び出し方法を記載します。  

- フックON/OFF(&C000)  
パラメーターに0を指定して実行するとフックON、1を指定して実行するとフックを解除します。  
重複実行してもフックを上書きしないようになっています。  





  


[![サンプルプレーWebMSX版](https://github.com/IKATEN-X/TouchpadMouse_forMSX0/blob/main/ScreenShot.png?raw=true)](https://webmsx.org/?MACHINE=MSX2J&DISK=https://github.com/IKATEN-X/TouchpadMouse_forMSX0/raw/main/OOTC_pen.dsk&MOUSE_MODE=0&FAST_BOOT=1)

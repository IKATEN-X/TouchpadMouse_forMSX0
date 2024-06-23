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
```
10 DEFUSR1=&HC000  
20 A=USR1(0)  'HOOK ON  
30 A=USR1(1)  'HOOK OFF
```
  
- 各種値取得(&C003)  
フックON時にマウスカーソルの座標とタップ結果を取得することができます。
パラメーターに与える値が0でタップ結果、1でY座標、2でX座標となっています。
画面タップを行うと結果に1が入り、その結果を取得すると保持している結果は0に戻りますので、連続して取得をすると1回だけ1が返ってきます。
```
10 DEFUSR2=&HC003  
20 A=USR2(0)  'TAP Result 
30 A=USR2(1)  'Y coordinate
40 A=USR2(2)  'X coordinate
```
  
- マウスカーソル位置のスクリーンバッファ用オフセットアドレス(&C006)  
WIDTH32のテキストモードでの使用を想定して、マウス座標位置に相当するオフセットアドレスを取得できます。  
AD=(Y\8)*32+X\8 の結果となっています。  
このオフセットアドレスにテキストのパターンネームテーブルのアドレス(&H1800)を足すと、直接VRAMにある文字をチェックできます。  
RAM上に配置した仮想テキストバッファのアドレスと足すと、VRAMのチェックより若干高速に文字のチェックも行えます。  
```
10 DEFUSR3=&HC006  
20 AD=USR3(0)  ' Offset Address
30 AD=AD+&H1800 ' a Pattern name address of coordinate
```

バイナリファイルは、 
MSX0は「TPMfor0.bin」、それ以外は「TPMforN0.BIN」を使用してください。  
TPMforN0.BINは、「TPMfor0.bin」の操作をエミュレータなどで、体験したり、MSX0でタッチパッドマウスを用いたプログラムを組む際に疑似的に同じ動作をするために作ったものです。  
マウスを使って画面をタッチパッドとして操作する感覚で使用することができます。  

この操作感覚を体験するために、簡単なBASICプログラムを用意しました。

- Order of the colors
[![WebMSX版サンプルプログラム](https://github.com/IKATEN-X/TouchpadMouse_forMSX0/blob/main/ScreenShot.png?raw=true)](https://webmsx.org/?MACHINE=MSX2J&DISK=https://github.com/IKATEN-X/TouchpadMouse_forMSX0/raw/main/OOTC_pen.dsk&MOUSE_MODE=0&FAST_BOOT=1)

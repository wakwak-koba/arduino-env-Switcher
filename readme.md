# arduino-env Switcher

### 機能
- ジャンクション機能を用いて ArduinoIDE の環境を切り替えます

### 切り替え対象のフォルダ
- %USERPROFILE%\.arduinoIDE
- %USERPROFILE%\AppData\Roaming\arduino-ide
- %USERPROFILE%\AppData\Local\arduino
- %USERPROFILE%\Documents\Arduino\libraries

### 使い方
1.適当な場所にフォルダを作成(実環境が保管される場所になる)  
2.当リポジトリのバッチファイルを配置  
3.ArduinoIDE.bat [環境値] として起動する(環境値を入れない場合は問い合わせされる)  
4.その環境値で独立した ArduinoIDE が起動する  
5.同時に、直接起動用のバッチファイルも自動生成され、次回からはそれを利用可  
6.環境変数 RAM_DRIVE を定義しておくと作業域を RAM_DRIVE に展開
7.ArduinoIDE_restore.bat で元の環境に戻る  

### 注意
- ジャンクション機能で切り替えているだけなので、異環境の同時起動は NG です。

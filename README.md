# lua-cjson for x68k's lua
[lua-cjson-2.1.0.14](https://github.com/openresty/lua-cjson?tab=readme-ov-file)をx68kのluaに組み込むためにビルドしました。

# 2025.12.30 更新
lua-5.5.0に組み合わせるために修正しました。
* Makefile でビルドするように方針変更 (Makefile2.x68は使わない方向で)
* warningを抑制するための修正を追加
・・・最終的に、以下のソースコードをlua-5.5.0のsrcディレクトリにコピーして、そこでlua本体と一緒にビルドするやり方に変更しました。
    * fpconv.c / fpconv.h
    * lua_cjson.c
    * strbuf.c / strbuf.h　

# ビルド
~~Makefile2.x68k~~ Makefileを参照ください。x68kのgcc2環境でビルドしています。  
lua_cjson.lファイルを作成していますが、筆者の場合はlua本体のsrcディレクトリに上述のファイルをコピーして、lua本体と一緒にコンパイル＆リンクするようにしました。  

#インストール
lua_cjson.lや.oファイルはlua本体とリンクするだけでいいですが、cjsonを使うためにはいくつか準備が必要です。  
* lua/cjsonディレクトリをluaのモジュールパスの通ったディレクトリにコピーします  
* 環境変素 LUAPATH を設定する。私の場合はこんな感じ： LUA_PATH=;;A:\\lualib\\?.lua;A:\\lualib\\?.luac  
*　具体的なAPI仕様や最低限の使い方は [cjsonのドキュメントのAPI仕様のあたり](https://github.com/openresty/lua-cjson/blob/master/manual.adoc)を見てください  

# その他
* x68k用の改変部分はオリジナルの [LICENSE](https://github.com/openresty/lua-cjson/blob/master/LICENSE) に従います
* x68k用の改変部分に [x68k libc](http://retropc.net/x68000/software/develop/lib/libc1132a/) の isinf() および isnan() のソースコードを流用しています。


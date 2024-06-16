# aqua

## aquaとは

- aquaはコマンドラインツールのバージョン管理をするツール。
- 今回の導入目的としてはGitHub Actions周りで使用するツールのバージョン管理を行うために導入する。

---

## install

> [公式install手順](https://aquaproj.github.io/docs/install)

```shell
go install github.com/aquaproj/aqua/v2/cmd/aqua@latest
sudo mv ~/go/bin/aqua /usr/local/bin/
```

上記の方法でインストールしたところ，`aqua -v`の結果がうまく表示されなくなったのでバイナリからインストールして配置した。

- aquaでインストールしたツールにパスが通るように設定

```
# bashrc
export PATH="$(aqua root-dir)/bin:$PATH"
```

## HowToUse

```shell
aqua init # aqua.yamlを作成
aqua i -l # これを実行しないとダウンロードしたツールが使えない。
aqua g -i suzuki-shunsuke/pinact
```

---

## Reference

- [github](https://github.com/aquaproj/aqua)
- [公式ドキュメント](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/what-aqua)

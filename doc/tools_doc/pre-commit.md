# pre-commit

## 概要

- gitのコミット時にlinter等を実行させるのに使う。

---

## install

```shell
pip install pre-commit
pre-commit sample-config > .pre-commit-config.yaml # すでに本リポジトリでは作成済み
pre-commit install

# ローカルでとりあえず動かしてみる。
pre-commit run -a
```
うまく動作してそうなら今後git commit時にツールが動作する。

### インストール時のエラー

- `AttributeError: module 'virtualenv.create.via_global_ref.builtin.cpython.mac_os' has no attribute 'CPython2macOsFramework'`がでている。これはvirtualenvに関連するエラーなのでupgradeしたりしてみる。
- [pipenv の初期化時に発生するエラー](https://qiita.com/akis1215/items/11c9ca506cac8bcde5d9)を参考に入れ直したら直った。

```shell
sudo pip3 uninstall virtualenv
sudo pip3 install virtualenv
```

---

## 使い方

- [pre-commit を使うサンプル](https://zenn.dev/yiskw713/articles/3c3b4022f3e3f22d276d)を見ながら設定する。
- **linterからエラーがでるとコミットできないので注意**
- .pre-commit-config.yamlをいじって`pre-commit install`してgit commitすると動作が確認できる。
- **デフォルトでは変更されたファイルに対してのみしか実行**されないので注意が必用。全体のチェックをしたいなら手動で行える。

```shell
pre-commit run --all-file
```

- 以下はhadolint(Dockerfileのリンター)を実行するための`.pre-commit-config.yaml`の例

```yaml
default_stages: [commit]
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
  - repo: https://github.com/hadolint/hadolint
    rev: v2.12.0
    hooks:
      - id: hadolint
        args: [--trusted-registry, grc.io, ./myapp/Dockerfile]
```

### よく使うオプション

> 詳細は[pre-commit 公式ドキュメントを見る](https://pre-commit.com/)

- id: [対応している hook 一覧](https://pre-commit.com/hooks.html)を見てコマンド名をいれておけばよさそう。
- rev: latestは指定できないのでメンテが必用そう
- files: スキャン対象を正規表現で絞れる。**スキャン対象のファイルが見つからない時につけても意味ない。**パスはidのargsで指定する。
- exclude: スキャン対象から除外するものを指定できる。

### eslint を使う

- .pre-commit-config.yaml

```yaml
default_stages: [commit]
repos:
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.54.0 # 一番新しいやつにした
    hooks:
      - id: eslint
        files: \.[jt]sx?$ # *.js, *.jsx, *.ts and *.tsx
```

> [!NOTE]
> node が古すぎると動かないみたいなので新しい node に変更して対応した。

```shell
pre-commit run --all-files
ERROR: npm v9.7.1 is known not to run on Node.js v10.19.0. This version of npm supports the following node versions: `^14.17.0 || ^16.13.0 || >=18.0.0`. You can find the latest version at https://nodejs.org/.
ERROR:/usr/local/lib/node_modules/npm/lib/utils/exit-handler.js:19 const hasLoadedNpm = npm?.config.loaded
```

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash # nvmインストール
source ~/.bashrc
nvm --version
nvm ls-remote # インストール可能なnodeの一覧
nvm install v20.9.0
nvm ls
nvm current # 現在使用しているバージョン確認
node --version
# 実行し直してみる
pre-commit install
pre-commit run -a
```

---

## エラー

- mdの最後が## testのような形で終わっており，タグに要素がないとエラーになる。

```shell
Fix End of Files.........................................................Failed
- hook id: end-of-file-fixer
- exit code: 1
- files were modified by this hook

Fixing todo.md
```

---

## Reference

- [対応している hook 一覧](https://pre-commit.com/hooks.html)

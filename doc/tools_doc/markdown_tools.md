# Markdown用のツール(VSCode例)

## README.mdをいい感じにする

### linterの導入

- [markdown-lint](https://github.com/markdownlint/markdownlint)

```shell
git clone https://github.com/markdownlint/markdownlint
cd markdownlint
rake install
```

- VSCodeのExtensionsmarkdown-linterを追加。settings.jsonは以下で設定。

#### 警告の抑止

- [設定項目の一覧](https://spure.dev/markdownlint_setting/)を見ながら対応する。
- markdown内での抑止はコメントを使う。

```md
<!-- markdownlint-disable MD033 -->
```

- VSCodeで使うならsettings.jsonによく使う警告設定をまとめておく。

```json
  // 抑止設定
  "markdownlint.config": {
    "MD010": false, // タブ
    "MD013": false // 長い行
  }
```

### formatterの導入

- ~~VSCodeのPrettierを使う~~
Prettierを使うと日本語と英語の間に謎の空白がはいるのでmarkdownlintをformatterとして使う。

```json
  // markdown
  "[markdown]": {
    "editor.defaultFormatter": "DavidAnson.vscode-markdownlint",
    "editor.formatOnSave": true,
  },
```

### VSCodeにsnippetsを設定する

- snippetは~/.config/Code/User/snippets/以下に格納する。
- .vscode/以下に配置するとプロジェクトメンバーで共有できる。
- command parreteで`snippets`を調べると言語ごとに登録可能。
- 使うときにはcommand parreteで`insert snippets`から
- [Language Identifiers](https://code.visualstudio.com/docs/languages/identifiers)を見てscopeに指定できるものを確認する。
- 本リポジトリでは[markdown.code-snippets](../../.vscode/markdown.code-snippets)に配置してある。

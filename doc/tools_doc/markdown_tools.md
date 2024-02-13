# Markdown用のツール(VSCodeの例)

## README.md

### linter
- [markdown-lint](https://github.com/markdownlint/markdownlint)

```shell
git clone https://github.com/markdownlint/markdownlint
cd markdownlint
rake install
```
- VSCodeのExtensionsmarkdown-linterを追加

#### 警告の抑止
- [設定項目の一覧](https://spure.dev/markdownlint_setting/)を見ながら対応する。
- [settings.json](#settings\.json)での抑止
- markdown内での抑止はコメントを使う。

```md
<!-- markdownlint-disable MD033 -->
```

### formatter
- VSCodeのPrettierを使う

### settings\.json

```json
  // markdown
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true,
  },
  // 抑止設定
  "markdownlint.config": {
    "MD010": false, # タブ
    "MD013": false # 長い行
  }
```

### snippetsについて
- snippetは~/.config/Code/User/snippets/以下に格納する。
- .vscode/以下に配置するとプロジェクトメンバーで共有できる。
- command parreteで`snippets`を調べると言語ごとに登録可能。
- 使うときにはcommand parreteで`insert snippets`から
- [Language Identifiers](https://code.visualstudio.com/docs/languages/identifiers)を見てscopeに指定できるものを確認する。
- 本リポジトリでは[markdown.code-snippets](../../.vscode/markdown.code-snippets)に配置してある。

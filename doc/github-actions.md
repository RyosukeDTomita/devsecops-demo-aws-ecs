# GitHub Actions 関連

> [!NOTE]
> 個々のツールの GitHub Actions の実行方法はツールごとのドキュメント参照。

## README バッチをつける

### GitHub Actions の Workflowの結果をバッチで表示

- リポジトリのActionsのページから**Create status badge**をクリックしてREADME.mdに貼り付ける。

![バッチのつけかた](./fig/badge.png)

### license を示すバッチ(おまけ)

Actionsに関係なくLICENSEファイルを配置しておけばよい

- `https://img.shields.io/github/license/<Github-Username>/<Repository>`のようにしてつける。
  ![no license](https://img.shields.io/github/license/RyosukeDTomita/devsecops-demo-aws-ecs)

---

## 特定のコミットを使って actions を実行する

コミットハッシュをつかうことでactionsで使うライブラリのバージョン管理ができる。

```yaml
actions/setup-python@コミットハッシュ
```

---

## GitHub ActionsでSecretを扱う

> GUIの場合は[公式ドキュメント](https://docs.github.com/ja/actions/security-guides/using-secrets-in-github-actions)参照。

### 2種類のシークレット

- Environment Secret: Environmentを作成して値を区別して使用できる。Environmentはリポジトリに対して複数作成できる。
- Repository Secret: リポジトリで共通の値を使う。

### 使用方法(CLI)

> [GitHub CLIでリポジトリへsecretを設定する方法](https://zenn.dev/hankei6km/articles/set-secret-to-repo-with-githubcli)
> [GitHub ActionsでEnvironment Secretを扱うサンプル](https://qiita.com/ak2ie/items/4fbcdf74e7760c49c1af)

- 個人的には.envから一括投入するのが使いやすそう。今回の例では--envを指定しているが指定しないとRepository Secretになる。

```shell
cat .env
API_TOKEN=xxxxxxxx
gh secret set --env environment名 --env-file .env
gh secret list --env development
```

- GitHub actionsのyamlから参照する。

```yaml
jobs:
  runs-on: ubuntu-latest
  environment:
    name: development # actionsのsecretの参照先を指定

  steps:
    -run: |
      echo ${{ secrets.API_TOKEN }}
```

---

## path filterを使って特定のファイル変更時のみCIを走らせる

- デフォルト設定だと，どのファイルが修正されてもCIが走ってしまうので必要なファイルが更新された時だけCIが起動できるようにする。

```shell
name: run-jest
on:
  push:
    paths:
      - "src/**.tsx"
      - "src/**.ts"
      - "public/**.html"
```

---

## Branch Protectionsのルールを使って必ず成功してほしいjobを指定する

### Branch Protectionsとは

- GitHubのリポジトリの設定から編集可能。
- Branchのforce-pushを禁止する等ブランチ単位でルールを設定できる。

### Branch ProtectionsでPR前に成功してほしいCIを指定する

- `Require status checks to pass before merging`を有効にし，必要なjobを選択する。
- yamlでいうところのjobs配下の要素が指定できる。

```yaml
jobs:
  frontend-jest: # ここが指定可能。
```

---

## CodeQLを使ってファイルを出力

### Advanced Security must be enabled for this repository to use code scanning 403: GitHub Advanced Security is not enabled

- publicリポジトリ以外で使用していると出るエラー。

- [公式ドキュメント](https://docs.github.com/ja/code-security/code-scanning/troubleshooting-code-scanning/advanced-security-must-be-enabled)を見ると
  - code scanningが有効になっている
  - GitHub Advanced Securityを実行しようとした場合
に出るエラーでcodd scanningが使えるのは無料ではpublicリポジトリのみ。

```yaml
        # reportsを生成(Actionsから確認できる)
        - name: save report as pipeline artifact
          uses: actions/upload-artifact@v4
          with:
            name: report.sarif
            path: report.sarif
        # scanの結果を解析。GithubのSecurity --> Code Scanning等でアラートが見られる。
        - name: publish code scanning alerts
          uses: github/codeql-action/upload-sarif@v2
          with:
            sarif_file: report.sarif
            category: semgrep
```

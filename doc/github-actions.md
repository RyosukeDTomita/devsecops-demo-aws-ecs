# GitHub Actions 関連

> [!NOTE]
> 個々のツールの GitHub Actions の実行方法はツールごとのドキュメント参照。

## README バッチをつける

### GitHub Actions の Workflowの結果をバッチでREADME.mdにつける

- リポジトリのActionsのページから**Create status badge**をクリックしてREADME.mdに貼り付ける。

![バッチのつけかた](./fig/badge.png)

### license を示すバッチ(おまけ)

Actionsに関係なくLICENSEファイルを配置しておけばよい

- `https://img.shields.io/github/license/<Github-Username>/<Repository>`のようにしてつける。
  ![no license](https://img.shields.io/github/license/RyosukeDTomita/devsecops-demo-aws-ecs)

---

## 特定のコミットを使って actions を実行する

- フルコミットハッシュをつかうことでactionsで使うライブラリのバージョンを固定できる。
- 他の指定方法では想定外のCIが走る恐れがある。
- [pinact](./tools_doc/pinact.md)を使うことで自動で数値のバージョンをフルコミットハッシュに変換できる。

```yaml
# 良い例
uses: actions/setup-python@コミットハッシュ

# 悪い例
uses: actions/setup-python@master # ブランチの最新が走る
uses: actions/setup-python@v1 # 1系の最新が走る
uses: actions/setup-python@v1.1.1 # tagの切り直しで想定外のCIが走る恐れ
```

---

## GitHub ActionsでSecret，variablesを扱う

> GUIの場合は[公式ドキュメント](https://docs.github.com/ja/actions/security-guides/using-secrets-in-github-actions)参照。

### Secret

#### 2種類のシークレット

- Environment Secret: Environmentを作成して値を区別して使用できる。Environmentはリポジトリに対して複数作成できる。
- Repository Secret: リポジトリで共通の値を使う。

#### 使用方法(CLI)

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

### variables

- 基本はsecretと同じでenvironment variablesとrepository variablesがある。
- secretと異なり，値を確認することができる。

#### 使用例

```shell
environment=development
gh variable set --env $environment --env-file .env.$environment
gh variable list --env $environment
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

- TODO: Actionsが通っていてもチェックがRequiredから変更されないので謎。

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

---

## matrixを使ってジョブを複数実行する

> [jobにmatrixを使用する](https://docs.github.com/ja/actions/using-jobs/using-a-matrix-for-your-jobs)

```yaml
jobs:
  frontend-jest: # job id(typed by user)
    runs-on: ubuntu-latest
    permissions:
      contents: read
    # デフォルトのワーキングディレクトリのため設定不要だが，明示的に指定。
    defaults:
      run:
        working-directory: /home/runner/work/devsecops-demo-aws-ecs/devsecops-demo-aws-ecs
    strategy:
      matrix:
        node_version: [20, 22]

    steps:
      # checkout repository to runner
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 # v4.1.7

      - name: set up node
        uses: actions/setup-node@60edb5dd545a775178f52524783378180af0d1f8 # v4.0.2
        with:
          node-version: ${{ matrix.node_version }}
```

成功すると以下のような感じになる。

![matrix image](./fig/matrix_test.png)

---

## GitHub Container RegistryにDockerイメージをpushする

- GitHub Container RegistryはGitHub Packagesの一部であり，Dockerイメージを保存するためのレジストリ。

```
# ghcr.ioに登録されたcacheを使ってimageをbuildし，cacheとimageを同時にpushする
docker buildx build --push -t ghcr.io/ryosukedtomita/devsecops-demo-aws-ecs --cache-to type=inline --cache-from type=inline .
```

- GitHub Actions経由でpushするにはPersonal Access Tokenが必要
  - repo
  - write:packages

[packages.yaml](../.github/workflows/packages.yaml)参照。

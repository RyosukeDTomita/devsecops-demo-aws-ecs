# github-comment

## github-commentとは

> [作者さんのブログ](https://zenn.dev/shunsuke_suzuki/articles/improve-cicd-with-github-comment)
> [使い方](https://github.com/suzuki-shunsuke/github-comment?tab=readme-ov-file)

- CIの結果を見やすくするために整形してコメントに投稿できる。

## install

ローカルにいれるというよりはGitHub Actionsから実行するのが良さそうだが一応インストール手順を書いておく。

```shell
aqua g -i suzuki-shunsuke/github-comment
aqua i -l
```

GitHub Actionsを使いたい場合には後述の手順を参照。

## 使い方

### 共通してやること

- github-comment.yaml(template)を用意する。

```shell
github-comment init
```

```yaml
---
skip_no_token: true
base:
  org: RyosukeDTomita
  repo: devsecops-demo-aws-ecs
post:
  default:
    template: |
      {{.Org}}/{{.Repo}} test
  hello:
    template: |
      hello world!
exec:
  hello:
    - when: true
      template: |
        {{template "header" .}}
        {{.Vars.foo}} {{.Vars.zoo.foo}}
        {{.Org}} {{.Repo}} {{.PRNumber}} {{.SHA1}} {{.TemplateKey}}
        exit code: {{.ExitCode}}

        ```console
        $ {{.Command}}
        ```

        Stdout:

        ```
        {{.Stdout}}
        ```

        Stderr:

        ```
        {{.Stderr}}
        ```

        CombinedOutput:

        ```
        {{.CombinedOutput}}
        ```
      template_for_too_long: |
        {{template "header" .}}
        {{.Vars.foo}} {{.Vars.zoo.foo}}
        {{.Org}} {{.Repo}} {{.PRNumber}} {{.SHA1}} {{.TemplateKey}}
        exit code: {{.ExitCode}}

        ```console
        $ {{.Command}}
        ```
```

- [GitHub Personal Access Token](https://docs.github.com/ja/enterprise-cloud@latest/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)を取得する。

### ローカルから試す

```shell
github-comment post --token <personal access token> --org RyosukeDTomita --repo devsecops-demo-aws-ecs --template hello --sha1 <commit hash>
```

### github-actionsから試す

- Personal Access TokenをGitHub Actionsのsecretに登録する。

- GitHub ActionsのWorkflow(`.github/workflows/`配下に作成。

> [!NOTE]
> 以下の例ではaquaを使ってgithub-commentをインストールして，実行している。
> また，成功する例と失敗する例を実行しており，失敗したときのみコメントが作成されていることを確かめる。
> [実行例](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/pull/32#issuecomment-2171981579)

```yaml
name: github-comment
on: [push]

defaults:
  run:
    shell: bash

jobs:
  github-comment-test: # job id(Typed by user)
    runs-on: ubuntu-latest

    steps:
      # Checkout repository to runner
      - uses: actions/checkout@f43a0e5ff2bd294095638e18286ca9a3d1956744 # v3.6.0
      - name: install package using aqua
        uses: aquaproj/aqua-installer@6ce1f8848ec8e61f14d57bd5d7597057a6dd187c # v3.0.1
        with:
          aqua_version: v2.29.0

      - run: github-comment post -k hello --token ${{ secrets.TOKEN }}
      - name: exit=0 then no comment
        run: github-comment exec --token ${{ secrets.TOKEN }} -- ls
      - name: exit!=0 then comment
        run: github-comment exec --token ${{ secrets.TOKEN }} -- ls /not_exist
```

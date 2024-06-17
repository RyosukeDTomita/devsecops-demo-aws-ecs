# DevSecOps demo React application for AWS ECS on Fargate

![no license](https://img.shields.io/github/license/RyosukeDTomita/devsecops-demo-aws-ecs)
[![jest](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/react-jest.yaml/badge.svg)](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/react-jest.yaml)
[![Semgrep](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/react-semgrep.yaml/badge.svg)](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/react-semgrep.yaml)
[![trivy-dependency-check](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/react-dependency-check.yaml/badge.svg)](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/react-dependency-check.yaml)
[![actions-lint](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/actions-linter.yaml/badge.svg)](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/actions/workflows/actions-linter.yaml)

## INDEX

- [ABOUT](#about)
- [ENVIRONMENT](#environment)
- [PREPARING](#preparing)
- [HOW TO USE](#how-to-use)
- [Error Log](#error-log)

---

## ABOUT

Sample React application for Trying to Use DevSecOps tools.

1. [PREPARING](#preparing)の設定を先にやる。
2. commit時にはpre-commitとgit-secretが作動。
3. push時にはGitHub ActionsによりSAST(semgrep)，UnitTest(jest)，Dependency Check(trivy)が実行される。
4. masterブランチにマージしたりmasterにpushした時にCodePipelineによってAWSへリポジトリがクローンされ，ビルド(image scanを含む)，developmentへのデプロイが始まる。
5. developmentで問題がなければCodePipeline上で承認し，productionへデプロイ

## ENVIRONMENT

### デプロイするアプリ

`create-react-app`で作られるデフォルトそのまま。

### GitHub Actions等(git push後)に使うツール

- [ghalint](./doc/tools_doc/ghalint.md): GitHub Actionsで実行されるworkflows用のlinter
- [github-comment](./doc/tools_doc/github-comment.md): GitHub Actionsで実行されるCIが失敗したときにコメントとしてエラーを出力する。
- [semgrep](./doc/tools_doc/semgrep.md)
- [trivy](./doc/tools_doc/trivy.md): イメージのスキャンやdependency checkができる。dependency checkはGitHub Actionsで実行，イメージスキャンはAWS Code Pipelineで実行。

- [aqua](./doc/tools_doc/aqua.md): GitHub Actionsで使用するCLIツールのバージョン管理ができる。
- [pinact](./doc/tools_doc/pinact.md): GitHub Actionsで使うactionsのバージョンをフルコミットハッシュに変換。

### pre-commit(git committ前)に使うツール

- [pre-commit](./doc/tools_doc/pre-commit.md): git commit前に特定のツールを実行し，失敗ならcommitさせない。
  - [hadolint](./doc/tools_doc/hadolint.md)
  - ESLint
  - Prettier(Formatter)
  - [Markdown linter](./doc/tools_doc/markdown_tools.md)
- [git-secret](./doc/tools_doc/pre-commit.md): git commit時にクレデンシャルのパターンにマッチするものがあれば，commitさせない。
- VSCode Extensions(Securityに関係のありそうなものだけ抜粋)
  - [hadolint](https://marketplace.visualstudio.com/items?itemName=exiasr.hadolint): Dockerfileのlinter
  - [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
  - [zenkaku](https://marketplace.visualstudio.com/items?itemName=mosapride.zenkaku): 半角スペースを可視化
  - [Code spell checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
  - ESLint
  - Prettier

---

### AWSの構成

AWS: ECS on FargateにCode Pipeline経由でデプロイする。サンプルではdevとprod環境を用意し、dev環境で動作確認後に承認ボタンを押すとprod環境のデプロイが進む形になっている。

- app-infrastructure-roles
  ![app-infrastructure-roles](./doc/fig/cfn/app-infrastructure-roles.png)
- app-infrastructure
  ![app-infrastructure](./doc/fig/cfn/app-infrastructure.png)
- environment
  ![env](./doc/fig/cfn/env.png)
- service
  ![svc](./doc/fig/cfn/svc.png)
- pipeline
  ![pipeline](./doc/fig/cfn/pipeline.png)

---

## PREPARING

### AWSの設定

[initialsettings_aws](./initialsettings_aws.md)を参照。

---

## HOW TO USE

- [PREPARING](#preparing)をやる。
- ローカルでのセットアップが必用なのは git-secretsのセットアップ。

```shell
cd devsecops-demo-aws-ecs
pre-commit install

git secrets --install
git secrets --register-aws # awsのクレデンシャル検知ルールを登録
```

- pre-commitのセットアップ

```shell
pip install pre-commit
pre-commit install
```

- VSCodeのExtensionsもお好みでインストール。
- GitHub Actionsがスキャン結果のファイルをアップロードできるように権限をつける。詳細は[semgrepのyaml](./.github/workflows/react-semgrep.yaml)を参照。

---

## Error Log

<details>
<summary>今まで詰まったエラー一覧</summary><div>

### Code Build のエラー

以下コマンドでログが見られる。ブラウザのAWS Code Deploy

```shell
copilot svc logs --previous
```

#### nginx: [emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)

- [ECS の仕様で非特権ユーザを使用したコンテナでは 80 番ポートが使えないっぽい](https://repost.aws/questions/QU1bCV9wT4T5iBrrP1c2ISfg/container-cannot-bind-to-port-80-running-as-non-root-user-on-ecs-fargate) --> つまり，localのdockerで80でサービスが起動できてもECSだと権限エラーになる。このため，コンテナで開放するportは8080としている(ALBに対して8080がマッピングされているためブラウザからは80でアクセスできる)。

#### toomanyrequests: You have reached your pull rate limit. You may increase the limit by authenticating and upgrading: <https://www.docker.com/increase-rate-limit>

- Docker Hubに短期間にアクセスしすぎているだけなので放置でOK

#### Error response from daemon: dockerfile parse error

- DockerfileのRUNをヒアドキュメントで書いていたら怒られた(ローカルでは動いてたのに...)

```dockerfile
# 修正前Dockerfile
RUN <<EOF
mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
touch /run/nginx.pid
chown -R nginx:nginx /run/nginx.pid
EOF

# 修正後
RUN mkdir -p /var/log/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && touch /run/nginx.pid \
    && chown -R nginx:nginx /run/nginx.pid
```

#### Resource handler returned message: "Error occurred during operation 'ECS Deployment Circuit Breaker was triggered'

コンテナが正常に起動していない。amd64を指定したら動いた。

```shell
DOCKER_DEFAULT_PLATFORM=linux/amd64 copilot deploy
```

#### copilot app show で CFn スタックを消したはずのアプリが表示されてしまう

- `copilot app show`はParameter Storeを見ているのでそこを消す。

</div></details>

# DevSecOps demo React application for AWS ECS on Fargate

## INDEX

- [ABOUT](#about)
- [ENVIRONMENT](#environment)
- [PREPARING](#preparing)
- [HOW TO USE](#how-to-use)
- [Error Log](#error-log)

---

## ABOUT

Sample for DevSecOps environment.
If you need help or questions, please contact [twitter](https://twitter.com/sigma5736394841), issues.

## ENVIRONMENT

- AWS
- GitHub Actions
- node:20

---

### AWS

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

### Automation Tools

See [./doc/tools_doc](./doc/tools_doc)

#### local tools

- pre-commit，git-secret

#### Using on GitHub Actions

- semgrep
- jest
- trivy(dependency check)

#### AWS CodePipeline

- trivy(image scan)

---

## PREPARING

### AWS Settings

copilot cli を使って環境構築を行う。

#### Create app

- 名前は任意だが，自分は react-app とした
- ここで必用な IAM ロールの一部や KMS のキーや CodePipeline に使う S3 やそのポリシーが作成されている。

```shell
copilot app init
cat ./copilot/.workspace
application: react-app
```

#### development 用のと production 用の 2 つの environment と service を作成する

- amd64 を指定しないとビルドエラーになる。
- 名前は任意だが，dev-env，dev-svc と prod-env，prod-svc とした。
- Type は Load Balancer を選択した。

```shell
DOCKER_DEFAULT_PLATFORM=linux/amd64 copilot init
```

- copilot/以下のファイルを編集することで設定を変更できる。

> [!NOTE]
> production と development で共通の VPC を使う場合には以下のようにして`copilot env init`単体で作成する。

<!-- markdownlint-disable MD033 -->
<details>
<summary>see detail</summary>
- 新しい VPC や，ECS の Cluster，Load Balancer や権限周りが作成される。

```shell
copilot env init
Environment name: prod-env

  Which credentials would you like to use to create hoge?  [Use arrows to move, type to filter, ? for more help]
    Enter temporary credentials
  > [profile default]


Environment name: prod-env
Credential source: [profile default]
Would you like to use the default configuration for a new environment?
    - A new VPC with 2 AZs, 2 public subnets and 2 private subnets
    - A new ECS Cluster
    - New IAM Roles to manage services and jobs in your environment
  [Use arrows to move, type to filter]
    Yes, use default.
    Yes, but I'd like configure the default resources (CIDR ranges, AZs).
  > No, I'd like to import existing resources (VPC, subnets).


Environment name: prod-env
Credential source: [profile default]
Default environment configuration? No, I'd like to import existing resources

  Which VPC would you like to use?  [Use arrows to move, type to filter]
  > vpc-xxxxxxxxxxxxxxxxx (copilot-react-app-dev-env)
```

</details>

- environment をデプロイ

```shell
copilot env deploy
```

- service をデプロイする。
  > [!WARNING]
  > この際に間違えて dev-svc や dev-env を選ばないように注意する。

```shell
DOCKER_DEFAULT_PLATFORM=linux/amd64 copilot svc init # サービス作成済みなら実行しない。
copilot svc deploy
```

- ブラウザからアクセスできるか試してみる。

```shell
copilot svc show # urlが出てくるのでそこにアクセスする
```

### CodePipeline の作成

- 名前は任意だが，自分は react-app-pipeline とした。

```shell
copilot pipeline init
```

- [manifest.yml](./copilot/pipelines/react-app-pipeline/manifest.yml)を編集して development でサービス開始後にユーザが承認した後に production にデプロイされるようにする。

```yaml
requires_approval: true
```

- 先に github に設定ファイルをアップロードしてから pipeline をデプロイする

```shell
git add .
git commit -m "add pipeline"
git push
copilot pipeline deploy
```

- ACTION REQUIRED が出るので URL にアクセスし，pending になっている pipeline と GitHub を接続する設定を追加する。
- 一度 pipeline をデプロイすると以後，指定した GitHub のブランチにマージされるたびに Code Pipeline を通してデプロイが進むようになる。

#### CodePipeline に image scan を追加する

- [./copilot/pipelines/react-app-pipeline/buildspec.yml](./copilot/pipelines/react-app-pipeline/buildspec.yml)を編集して trivy による image scan を追加する。

```yaml
install:
  commands:
    - echo "install trivy"
    - rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.48.0/trivy_0.48.0_Linux-64bit.rpm
```

```yaml
# Run trivy scan on the docker images.
- trivy image --vuln-type os --no-progress --format table -o container-scanning-report.txt --severity CRITICAL,HIGH $(jq -r '.Parameters.ContainerImage' ./infrastructure/dev-svc-dev-env.params.json)
- cat container-scanning-report.txt
```

<details>
<summary>buildspec.ymlの解説</summary><div>
- ./infrastructureをビルドによって作成しており，この中にECRのイメージが書いてあるのでこれをjqコマンドで抜き出している。
- trivyに関する詳細は[./doc/tools_doc/trivy.md]を確認。

```shell
cat ./infrastructure/dev-svc-dev-env.params.json
{
  "Parameters": {
    "AddonsTemplateURL": "",
    "AppName": "react-app",
    "ContainerImage": "xxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/react-app/dev-svc:xxxxxx-xxxxx-xxxx-xxxx-xxxxxxxxxxxx-dev-env",
  }
}
jq -r '.Parameters.ContainerImage' ./infrastructure/dev-svc-dev-env.params.json
xxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/react-app/dev-svc:xxxxxx-xxxxx-xxxx-xxxx-xxxxxxxxxxxx-dev-env
```

</div></details>

---

## その他の設定

- ローカルでのセットアップが必用なのは git-secrets と pre-commit くらい
- [pre-commit のドキュメント](./doc/tools_doc/pre-commit.md)
- [git-secrets のドキュメント](./doc/tools_doc/git-secret.md)

```shell
cd devsecops-demo-aws-ecs
pre-commit install

git secrets --install
git secrets --register-aws # awsのクレデンシャル検知ルールを登録
```

- VSCode の Extensions もお好みで。Docker の hadolint はおすすめ。

- GitHub Actions がスキャン結果のファイルをアップロードできるように権限をつける。詳細は[semgrep の yaml](./.github/workflows/react-semgrep.yaml)を参照。

---

## HOW TO USE

1. [PREPARING](#preparing)の設定を先にやる。
2. commit 時には pre-commit と git-secret が作動
3. push 時には GitHub Actions により SAST(semgrep)，UnitTest(jest)，Dependency Check(trivy)が実行される。
4. master ブランチにマージしたり master に push した時に CodePipeline によって AWS へリポジトリがクローンされ，ビルド(image scan を含む)，development へのデプロイが始まる。
5. development で問題がなければ CodePipeline 上で承認し，production へデプロイ

---

## Error Log

### nginx: [emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)

- [ECS の仕様で非特権ユーザを使用したコンテナでは 80 番ポートが使えないっぽい](https://repost.aws/questions/QU1bCV9wT4T5iBrrP1c2ISfg/container-cannot-bind-to-port-80-running-as-non-root-user-on-ecs-fargate) --> つまり，local の docker で 80 でサービスが起動できても ECS だと権限エラーになる。このため，コンテナで開放する port は 8080 としている(ALB に対して 8080 がマッピングされているためブラウザからは 80 でアクセスできる)。

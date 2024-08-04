# GitHub-pagesを使う

## 初期設定

### package.jsonに設定追加

```json
# FIXME: 自分のリポジトリ名と同じにする
  "homepage": "https://ryosukedtomita.github.io/<リポジトリ名>",
```

> [!NOTE]
> ローカルで`docker compose up`とかした際にhomepageが設定されているとうまくいかないの2024/08/04現在ではgithub actionsのyaml内でpackage.jsonを編集している。

### GitHub側の設定

- リポジトリの設定からPages --> Build and deploymentをGitHub Actions を選択する。

> [GitHub Pages](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/settings/pages)

---

## github pagesにデプロイ

`git push origin master`後に[package.json](./package.json)に設定したurlにアクセスする。

---

## ERROR LOG

### Branch "master" is not allowed to deploy to github-pages due to environment protection rules

- github actionsのdeploy時に何故かdeployが失敗する。
- おそらくバグだとおもわれ(2024/02/02)，Pagesの設定ページのSourceを一度Deploy from a branchに変更してBranchをmainからmasterに変更した後，再度SourceをGitHub Actionsに変更したら直った。

### テスト用ブランチからもgithub pagesにデプロイしたい

- [repositoryのsettings](https://github.com/RyosukeDTomita/devsecops-demo-aws-ecs/settings/environments)からprotection ruleを変更し，ブランチ名を追加する。

# github-comment

## github-commentとは

> [作者さんのブログ](https://zenn.dev/shunsuke_suzuki/articles/improve-cicd-with-github-comment)
> [使い方](https://github.com/suzuki-shunsuke/github-comment?tab=readme-ov-file)

- CIの結果を見やすくするために整形してコメントに投稿できる。

## install

正直ローカルにいれるというよりはGitHub Actionsから実行するのが良さそうだが一応インストール手順を書いておく。

```shell
aqua g -i suzuki-shunsuke/github-comment
aqua i -l
```

## 使い方

ブランチがリモート(github.com)に存在しないとエラーが出る。

```shell
github-comment post -k test
opts is invalid: org is required
```

# pinact

## pinactとは

- GitHub Actionsのactionのバージョンが実行タイミングによって内容が変わると突然CIが壊れたり，悪意のあるコードが実行される可能性がある --> フルコミットハッシュを用いてバージョンを固定すべきである。
- pinactを使うとフルコミットハッシュに変換し，コメントでバージョンを記載してくれる。

## install

- [GitHub](https://github.com/suzuki-shunsuke/pinact#install)をみてinstallする。

```shell
aqua g -i suzuki-shunsuke/pinact
```

## HOW TO USE

```shell
pinact run
```

- actions/ツール名@f43a0e5ff2bd294095638e18286ca9a3d1956744 # v3.6.0 のような表記に変換してくれる。

```yaml
uses: actions/checkout@f43a0e5ff2bd294095638e18286ca9a3d1956744 # v3.6.0
```

---

## Error log

### 401 Bad credentials

```shell
pinact run
WARN[0000] get a reference error="GET https://api.github.com/repos/aquasecurity/trivy-action/commits/v0.21.0: 401 Bad credentials []" pinact_version=0.2.0 program=pinact workflow_file=.github/workflows/react-dependency-check.yaml
```

[公式のREADME](https://github.com/suzuki-shunsuke/pinact#github-access-token)を見ると，

> pinact calls GitHub REST API to get commit hashes and tags. You can pass GitHub Access token via environment variable GITHUB_TOKEN. If no GitHub Access token is passed, pinact calls GitHub REST API without access token.

のような記載があり，GITHUB_TOKENをexportしているとそれを使ってpinactを起動しようとするらしい。
そのため，GITHUB_TOKENをunexportしたら解決。

### 422 No commit found for SHA

たまに，pinactがフルコミットハッシュを取得できないことがあるので手動でreleaseに関連付けられているコミットハッシュをurlから取得して記載することで[ghalint](./ghalint.md)のエラーを消せる。

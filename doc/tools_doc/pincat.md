# pincat

## pincatとは

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

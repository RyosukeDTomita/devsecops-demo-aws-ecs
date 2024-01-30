# GitHub Actions 関連
> [!NOTE]
> 個々のツールのGitHub Actionsの実行方法はツールごとのドキュメント参照。

## READMEにバッチをつける

- リポジトリのActionsのページから**Create status badge**をクリックしてREADME.mdに貼り付ける。

![バッチのつけかた](./fig/badge.png)
******


## 特定のコミットを使ってactionsを実行する。

```yaml
actions/setup-python@コミットハッシュ
```

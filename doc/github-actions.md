# GitHub Actions 関連

> [!NOTE]
> 個々のツールの GitHub Actions の実行方法はツールごとのドキュメント参照。

## README にバッチをつける

### GitHub Actions の Workflow

- リポジトリのActionsのページから**Create status badge**をクリックしてREADME.mdに貼り付ける。

![バッチのつけかた](./fig/badge.png)

### license を示すバッチをつける

- `https://img.shields.io/github/license/<Github-Username>/<Repository>`のようにしてつける。
  ![no license](https://img.shields.io/github/license/RyosukeDTomita/devsecops-demo-aws-ecs)

---

## 特定のコミットを使って actions を実行する

```yaml
actions/setup-python@コミットハッシュ
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

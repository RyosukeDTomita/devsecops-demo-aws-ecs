# semgrep
## semgrep install

```shell
python3 -m pip install semgrep
semgrep signin
```

```shell
semgrep ./frontend-app
```

### VSCode Extensions
- 最初にSign inする必用がある。
- Ctrl shift pで実行する。

### Github Actionsでsemgrepを使う。
- 事前にリポジトリの設定から --> Code and automation --> Actions --> GeneralのWorkflow permissionsをRead and write permissionsに変更しておく必用がある。

```
name: Semgrep Full Scan

on:
  push:
  schedule:
    # 日曜日の午前0時に実行
    - cron:  '0 0 * * 0'

jobs:

  semgrep-full:
      runs-on: ubuntu-latest
      container:
        image: returntocorp/semgrep

      steps:
        - name: clone application source code
          uses: actions/checkout@v3

        - name: full scan
          run: |
            semgrep \
              --sarif --output report.sarif \
              --metrics=off \
              --config="p/default"
        # reportsを生成(Actionsから確認できる)
        - name: save report as pipeline artifact
          uses: actions/upload-artifact@v3
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
******


## 参考
- [semgrep github actions](https://0xdbe.github.io/GitHub-HowToEnableCodeScanningWithSemgrep/)

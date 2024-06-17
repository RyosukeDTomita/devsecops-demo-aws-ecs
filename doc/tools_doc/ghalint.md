# ghalint

## ghalintとは

---

## install

```shell
aqua g -i suzuki-shunsuke/ghalint@v0.2.11
```

---

## How to Use

```shell
ghalint run
```

- [ghalintが検知してPolicy](https://github.com/suzuki-shunsuke/ghalint?tab=readme-ov-file#policies)をみて修正する。

---

## 修正log

### All jobs should have the field permissions

- [内容](https://github.com/suzuki-shunsuke/ghalint/blob/main/docs/policies/001.md): すべてのjobにpermissionをつけないといけない。
- [permissionsの一覧が載っているページ](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idpermissions)を参照。

```yaml
jobs:

  trivy-scan:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
```

> [!NOTE]
> [codeql-action](https://github.com/github/codeql-action/issues/464)には`security-events: write`が必要

### the step violates policies

- [内容](https://github.com/suzuki-shunsuke/ghalint/blob/main/docs/policies/008.md): フルコミットハッシュにすれば解決。
- [pinact](./pinact.md)を使うと簡単に修正できる。

### the job violates policies

imageにタグがついてなかったので修正。

```yaml
image: returntocorp/semgrep:sha-69df2e1
```

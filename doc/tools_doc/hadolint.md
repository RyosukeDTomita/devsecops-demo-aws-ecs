# hadolint の使い方

## 概要

> [hadolint github](https://github.com/hadolint/hadolint)
> Dockerfile を綺麗にするツール。

---

## install

```shell
sudo wget -O /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64
sudo chmod 755 /usr/bin/hadolint
```

---

## 実行

```shell
ls
myapp/  pre-commit-setup.sh
hadolint --trusted-registry grc.io ./myapp/Dockerfile # --trusted-registryに登録されているイメージ以外で警告を出す。
./myapp/Dockerfile:1 DL3026 error: Use only an allowed registry in the FROM image
./myapp/Dockerfile:7 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
```

---

## エラー例

- /Dockerfile:7 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation. --> RUN を一つにまとめたほうがイメージのレイヤーを最小化できる。

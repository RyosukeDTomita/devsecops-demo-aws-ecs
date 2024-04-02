# Tryvy

## インストール

> [インストール方法](https://aquasecurity.github.io/trivy/v0.18.3/installation/)

```shell
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

---

## オプション

- --vuln-typeは`os`と`library`が選べる。指定しないと両方になる。これは絞らなくても良さそう。
- --no-progress: 進捗バーを表示しない。CI/CDで出力をシンプルにする。
- --exit-code 1: スキャンで脆弱性が出た時にステータスコード1を返すため，CI/CDツールなどで結果を評価しやすくなる。
- --format table: 結果をテーブル形式で表示
- fs: ファイルスキャンモード
- --scanners vuln: 脆弱性スキャンモードを指定。Secrets(デフォルトon)やmisconfig(デフォルトではoff)，license(デフォルトではoff)なども指定できる
- --vuln-type library: スキャン対象をライブラリに限定する。

---

## 使用したコマンド

> [trivy ドキュメント](https://aquasecurity.github.io/trivy/v0.22.0/)
> .trivyignore ファイルに CVE 番号などを記述することで抑止できる。

### イメージスキャン

```shell
trivy image --exit-code 1 --vuln-type os --ignorefile .trivyignore --no-progress --format table -o container-scanning-report.txt --severity CRITICAL,HIGH react-app:latest
```

### package.json のスキャン

```shell
trivy fs --exit-code 1 --scanners vuln --vuln-type library --ignorefile .trivyignore --no-progress --format table -o sca-report.txt --severity CRITICAL,HIGH package.json
```

> [他のサブコマンドが知りたくなったらここ](https://aquasecurity.github.io/trivy/v0.22.0/getting-started/cli/)

### sbom 形式で出力する

#### ライブラリの脆弱性を調べる(package.json)

```shell
npm install jquery # 調べたい対象
vim package-lock.json # 任意のバージョンに書き換え

trivy fs . --format cyclonedx --output test.json # sbom形式で出力
trivy sbom test.json # sbomを解釈
```

#### docker image のスキャン

- Docker imageで使っているライブラリの脆弱性を探す。
- Dockerfileを用意する

```shell
FROM registry.access.redhad.com/ubi8/ubi:8.2

RUN dnf update -y
RUN dnf install -y httpd-2.4.37

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D" "FOREGROUND"]
```

- ビルドしてスキャンする

```shell
sudo docker buildt -t testimage .
sudo trivy image testimage --format cyclonedx --output test.json
trivy sbom test.json
```

---

## エラー

- imageスキャンでコンテナを実行していない(`docker container ps`がない)時のエラー

```shell
2023-12-05T22:31:00.272+0900	FATAL	image scan error: scan error: unable to initialize a scanner: unable to initialize a docker scanner: 4 errors occurred:
	* unable to inspect the image (react:latest): Error response from daemon: No such image: react:latest
	* image not found in containerd store: react:latest
	* unable to initialize Podman client: no podman socket found: stat podman/podman.sock: no such file or directory
	* GET https://index.docker.io/v2/library/react/manifests/latest: UNAUTHORIZED: authentication required; [map[Action:pull Class: Name:library/react Type:repository]]
```

---

## Reference

- [CodeBuild で Trivy を実行](https://tukunen13.hatenablog.jp/entry/2021/12/20/000000)

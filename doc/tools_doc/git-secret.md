# git secrets
- パスワードのシークレットと思われる文字列を検知する。
- pre-commitを使って実装されているらしい。
## 環境構築

```shell
cd ~/Downloads
wget https://github.com/awslabs/git-secrets/archive/refs/tags/1.3.0.tar.gz
tar zxvf 1.3.0.tar.gz
cd git-secrets-1.3.0/
ls
sudo make install
git secrets # 動作確認
```
## 使用方法
- プロジェクトに移動して以下を実行

```shell
git secrets --install
git secrets --register-aws # awsのクレデンシャル検知ルールを登録
git secrets --list # 設定を確認
git secrets --scan # スキャン
```
- また，コミットしようとした際にもscanが実行されており，特定の文字列が検知されるとコミットできなくなる。

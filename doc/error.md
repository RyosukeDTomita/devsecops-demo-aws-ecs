# Error Log

## コンテキストパスを変えてみた際のReactとnginxの仕様

### React側

- [package.json](../package.json)のhomepageを変更することで`npm run start`や`npm run build`を使ってビルドした際にホストする場所が変わる

```json
  "homepage": "http://localhost/hoge",
```

```shell
npm start
curl localhost:3000/hoge # こっちが推奨だがどっちでも良さそう。
curl localhost:3000/hoge/
```

### nginx側

- `location`と`alias`を使うことでデプロイするアプリを変えられる。

```
# nginx.conf
        # location /hoge/にすると403 Forbiddenになる。
        location /hoge {
            alias /usr/share/nginx/html;
        }
```

```shell
curl localhost/hoge/ # 成功
curl localhost/hoge # Unable to connect
```

> [!NOTE]
> package.jsonの`homepage: ""`の状態だと，localhost/hoge/とlocalhost両方でアプリにアクセスできるようになる。

---

## nginxのエラーページのバージョン情報を消す
- 以下の条件が揃った状態で[localhost/hoge](http://localhost/hoge)にアクセスすると403 Forbiddenが発生する。

```json
  "homepage": "http://localhost/hoge",
```

```
# nginx.conf
        location /hoge/ {
            alias /usr/share/nginx/html;
        }
```

- エラーページのバージョンを抑止するには`server_tokens off;`を設定する。

```
# nginx.conf
http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    server_tokens off; # Error page version off
```

# 対応ログ
## hadolint
- 対応前はRUNが複数あったので修正。rootでサービス起動しないように修正。

```shell
hadolint Dockerfile
Dockerfile:6 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
Dockerfile:16 DL3002 warning: Last USER should not be root
```

```
# ビルド環境
FROM node:20 as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build


# プロダクション環境
FROM public.ecr.aws/eks-distro-build-tooling/eks-distro-minimal-base-nginx:latest-al23
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
USER root
EXPOSE 80
# rootに変えないと権限エラーになる。
USER root
CMD ["nginx", "-g", "daemon off;"]
```

- 信頼されたイメージを使う TODO

```shell
hadolint --trusted-registry grc.io ./Dockerfile
./Dockerfile:2 DL3026 error: Use only an allowed registry in the FROM image
./Dockerfile:9 DL3026 error: Use only an allowed registry in the FROM image
```

- rootユーザで実行したくないがrootじゃないと80番portが開かない。他のport(8080を試すもうまく行かないので一旦rootで実行)

```shell
copilot svc logs --previous
Found only one application, defaulting to: test-app
Found only one deployed service app-svc in environment test-env
previously stopped task: 82fc7e8b1c164d18a8ffdeb9bb167d4e
copilot/app-svc/82fc7e8b1 nginx: [alert] OPENSSL_init_ssl() failed (SSL: error:80000002:system library::No such file or directory:calling stat(/etc/crypto-policies/back-ends/opensslcnf.config) error:07000075:configuration file routines::ssl command section empty:name=system_default, value=crypto_policy error:0700006D:configuration file routines::module initialization error:module=ssl_conf, value=ssl_module retcode=-1      )
copilot/app-svc/82fc7e8b1 nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:5
copilot/app-svc/82fc7e8b1 nginx: [emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)
iceman@x1carbon:~/memo/pc/cloud/aws/ecs$ copilot svc logs --previous
Found only one application, defaulting to: roulette-app
Found only one deployed service roulette-svc in environment roulette-env
previously stopped task: 910199e1c8924cfbb1839789e84ef523
copilot/roulette-svc/9101 nginx: [alert] OPENSSL_init_ssl() failed (SSL: error:80000002:system library::No such file or directory:calling stat(/etc/crypto-policies/back-ends/opensslcnf.config) error:07000075:configuration file routines::ssl command section empty:name=system_default, value=crypto_policy error:0700006D:configuration file routines::module initialization error:module=ssl_conf, value=ssl_module retcode=-1      )
copilot/roulette-svc/9101 nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:5
copilot/roulette-svc/9101 nginx: [emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)
```

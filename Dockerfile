# ビルド環境
FROM node:20 as build
WORKDIR /app
COPY . .
RUN npm install && npm run build


# プロダクション環境
FROM public.ecr.aws/eks-distro-build-tooling/eks-distro-minimal-base-nginx:latest-al23
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# rootユーザ以外でサービスを起動するために最低限の権限を付与
USER root
RUN <<EOF
mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
touch /run/nginx.pid
chown -R nginx:nginx /run/nginx.pid
EOF


EXPOSE 80
#USER nginx
CMD ["nginx", "-g", "daemon off;"]

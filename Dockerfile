# Build Image
FROM node:20 AS build
WORKDIR /app

# defaultをdevelopmentにし，引数でproductionにも切り替えられるようにする
ARG BUILD_ENV=development

COPY . .

# npm startは.env.developmentが優先されるがnpm run buildでは.env.productoinが優先されるので注意。
RUN <<EOF
npm install
if [ "$BUILD_ENV" = "development" ]; then
echo "build mode = development"
npm run build
elif [ "$BUILD_ENV" = "staging" ]; then
echo "build mode = staging"
elif [ "$BUILD_ENV" = "productoin" ]; then
echo "build mode = production"
npm run build-dev
else
echo "build mode = unknown"
exit 1
fi

rm -rf node_modules/.cache
EOF


# Product Image
FROM public.ecr.aws/eks-distro-build-tooling/eks-distro-minimal-base-nginx:latest-al23

# Change owner to allow non-root users to start the service
USER root
RUN <<EOF
mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
touch /run/nginx.pid
chown -R nginx:nginx /run/nginx.pid
EOF

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
USER nginx
CMD ["nginx", "-g", "daemon off;"]

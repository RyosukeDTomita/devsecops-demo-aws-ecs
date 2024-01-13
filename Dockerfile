# Build Image
FROM node:20 as build
WORKDIR /app
COPY . .
RUN npm install && npm run build


# Product Image
FROM public.ecr.aws/eks-distro-build-tooling/eks-distro-minimal-base-nginx:latest-al23

# Change owner to allow non-root users to start the service
USER root
RUN mkdir -p /var/log/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && touch /run/nginx.pid \
    && chown -R nginx:nginx /run/nginx.pid

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

# Use 8080 instead of 80 to avoid the `nginx: [emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)` when using ECS.
EXPOSE 8080
USER nginx
CMD ["nginx", "-g", "daemon off;"]

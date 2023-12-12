# Build Image
FROM node:20 as build
WORKDIR /app
COPY . .
RUN npm install && npm run build


# Product Image
FROM public.ecr.aws/eks-distro-build-tooling/eks-distro-minimal-base-nginx:latest-al23
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
#COPY default.conf /etc/nginx/conf.d/default.conf


# Change owner to allow non-root users to start the service
USER root
# RUN <<EOF
# mkdir -p /var/log/nginx
# chown -R nginx:nginx /var/log/nginx
# touch /run/nginx.pid
# chown -R nginx:nginx /run/nginx.pid
# EOF
RUN mkdir -p /var/log/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && touch /run/nginx.pid \
    && chown -R nginx:nginx /run/nginx.pid


EXPOSE 80
USER nginx
CMD ["nginx", "-g", "daemon off;"]

# Using Nginx Alpine as base Image (16 MB archived but 42 MB deployed)
# base_image_publish_date: 2023.05.25
FROM nginx:alpine3.17

# Copy webapp src into Nginx DocumentRoot directory inside container
#COPY ./src/* /usr/share/nginx/html/
#COPY ./configs/nginx/webapp.conf /etc/nginx/conf.d/default.conf
#COPY ./configs/nginx/health-check.conf /etc/nginx/conf.d/health-check.conf
#
COPY src/ /usr/share/nginx/html/
COPY configs/nginx/webapp.conf /etc/nginx/conf.d/default.conf
COPY configs/nginx/health-check.conf /etc/nginx/conf.d/health-check.conf

# Run Nginx from container (for Ubuntu base images)
#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
#
# We did not add an ENTRYPOINT or a CMD to our Dockerfile.
# We will use the underlying ENTRYPOINT and CMD provided by the base Nginx image.
#

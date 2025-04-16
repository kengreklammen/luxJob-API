# dockerfile 

FROM rocker/tidyverse:4.4.3

# Install dependencies and utilities
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    make \
    zlib1g-dev \
    libsodium-dev \
    libicu-dev

run mkdir /home/myapi

# Workaround for renv cache
RUN mkdir /.cache
RUN chmod 777 /.cache

RUN R -e "install.packages('renv')"

# Set the working directory to /app
WORKDIR /home/myapi

# Copy the entire app directory into the container
COPY . .

# install renv & restore packages
RUN R -e 'renv::consent(provided = TRUE)'
RUN R -e "renv::restore()"

# expose port
EXPOSE 8008
CMD ["R", "-e", "/home/myapi/run_plumber_bearer_auth.R"]
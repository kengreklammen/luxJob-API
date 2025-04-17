# dockerfile 

FROM rocker/tidyverse:4.4.3

#COPY ./renv.lock /

# Install dependencies and utilities
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    make \
    zlib1g-dev \
    libsodium-dev \
    libicu-dev

#run mkdir /home/myapi

RUN R -e "install.packages('renv')"

# Set the working directory to /app
WORKDIR /
#RUN ls -la /
# Copy the entire app directory into the container
COPY . .
#RUN ls -la /
# install renv & restore packages
RUN R -e 'renv::consent(provided = TRUE)'
RUN R -e "renv::restore()"

# expose port
EXPOSE 8008
#CMD ["R", "-e", "./run_plumber_bearer_auth.R"]
ENTRYPOINT ["Rscript", "run_plumber_bearer_auth.R"]
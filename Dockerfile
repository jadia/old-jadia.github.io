# jekyll Docker container to run the website

FROM jekyll/jekyll 
LABEL maintainer="nitish@jadia.dev" 
LABEL version="1.0"
LABEL description="Dockerfile installs jekyll \
    and it's dependencies."


WORKDIR /srv/jekyll/
RUN gem install redcarpet \
    jekyll-gist \
    pygments.rb \
    rouge

EXPOSE 4000
CMD "jekyll" "serve"
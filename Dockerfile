### Local development only ###

#FROM ruby:2.6-alpine
FROM ruby:2.5.1-alpine
#RUN \
#      wget -qO- https://deb.nodesource.com/setup_9.x | bash - && \
#      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#      apt-get update -qq && \
#      apt-get install -y --force-yes --no-install-recommends \
#      nodejs yarn build-essential libpq-dev default-mysql-client sqlite3 && \
#      apt-get clean
#RUN gem install bundler

RUN apk add --update --no-cache \
  bash \
  build-base \
  git \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  mysql \
  mysql-client \
  mysql-dev  \
  tzdata

RUN gem update --system && \
  gem install bundler && \
  bundle config build.nokogiri --use-system-libraries


# Install bash
#RUN apk add --no-cache bash && apk add curl

# Create working directory
RUN mkdir -p /home/hdc

# Set working directory
WORKDIR /home/hdc

# Copy code
COPY . /home/hdc

# Expose ports
EXPOSE 3000

#RUN npm install

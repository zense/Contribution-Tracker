FROM ruby:2.4

# Install all dependencies upfront so the docker build can be cached
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y cron
ENV RAILS_ENV=production

WORKDIR /app
ADD .gemrc /app
ADD Gemfile /app/
ADD Gemfile.lock /app/

# If you are using gemstash then uncomment the below line.
# RUN bundle config mirror.https://rubygems.org http://172.17.0.1:9292

RUN bundle install --jobs 8

ADD . /app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s"]

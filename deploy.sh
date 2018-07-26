#!/usr/bin/env bash

# Inititalize all variables
ENV="$1"
BRANCH="${2:-master}"
MODE="${3:-all}"

# Check Variables
if [ -z $ENV ]; then
  echo "No environment specified"
  exit 1
fi
if [ $MODE != "all" ] && [ $MODE != "server" ] && [ $MODE != "sidekiq" ]; then
  echo "Valid modes are all, server, sidekiq"
  exit 1
fi

echo "Deploying $MODE with $BRANCH in $ENV environment"

# Fetch latest code
git fetch origin --prune
git reset --hard origin/$BRANCH

# Initialize env and folders
export RAILS_ENV=$ENV
mkdir tmp/pids
mkdir tmp/sockets

# Install all gems
bundle install

# Run all migrations
rake db:migrate

# Run deploy task
rake deploy

# Restart puma
if [ $MODE == "all" ] || [ $MODE == "server" ]; then
  script/puma.sh restart
fi

# Restart sidekiq
if [ $MODE == "all" ] || [ $MODE == "sidekiq" ]; then
  script/sidekiq.sh restart
fi

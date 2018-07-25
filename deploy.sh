#!/bin/bash

# Inititalize all variables
ENV="$1"
BRANCH="${2:-master}"
if [ -z $ENV ]; then
  echo "No environment specified"
  exit 1
fi
echo "Deploying $BRANCH in $ENV environment"

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
script/puma.sh restart

# Restart sidekiq
script/sidekiq.sh restart

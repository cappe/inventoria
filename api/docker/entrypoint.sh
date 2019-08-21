#! /bin/sh

./docker/wait-for-services.sh
./docker/prepare-db.sh
./docker/prepare-cron.sh

bundle exec puma -C config/puma.rb

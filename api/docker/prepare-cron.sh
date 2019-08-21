#! /bin/sh

echo "Initializing crond..."
crond

echo "Updating crontab..."
whenever --update-crontab --set environment="${RAILS_ENV}"

echo "Crontab updated!"

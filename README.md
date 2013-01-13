bundle install --without sqlite mysql
bundle exec rake db:initial_setup
bundle exec rake canvas:compile_assets
bundle exec script/server

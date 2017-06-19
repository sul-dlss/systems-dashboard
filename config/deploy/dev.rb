set :deploy_to, '/home/reporting/systems-dashboard'
server 'sulreports-dev.stanford.edu', user: 'reporting',
                                              roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!

set :branch, 'jonrober'
set :rails_env, 'development'

set :deploy_to, '/home/reporting/systems-dashboard'
server 'sulreports.stanford.edu', user: 'reporting',
                                              roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!

set :branch, 'main'
set :rails_env, 'production'

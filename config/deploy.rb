# config valid only for current version of Capistrano
lock '3.16.0'

set :application, 'systems-dashboard'
set :repo_url, 'http://github.com/sul-dlss/systems-dashboard.git'

set :branch, ENV.fetch('BRANCH', 'main')

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

#:user
#:home_dir
#:repository - try to not include sunetid in this url

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml',
                                                 'config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache',
                                               'tmp/sockets', 'vendor/bundle',
                                               'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

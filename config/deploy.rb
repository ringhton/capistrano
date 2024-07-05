# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"

set :application, "symfony_with_capistrano"
set :repo_url, "https://github.com/symfony/demo.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, "main"
#set :scm, :git
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/symfony"
set :deploy_via, :remote_cache
# Install composer if it does not exist
set :composer_install_flags, '--no-interaction --quiet --optimize-autoloader'
#set :composer_install_flags, '--no-dev --no-interaction --quiet --optimize-autoloader'
set :composer_roles, :all
set :composer_working_dir, -> { fetch(:release_path) }
set :composer_dump_autoload_flags, '--optimize'
set :composer_download_url, "https://getcomposer.org/installer"
SSHKit.config.command_map[:composer] = "php #{shared_path.join("composer.phar")}"

namespace :deploy do
  after :starting, 'composer:install_executable'
#  after :starting, 'composer:install'
end
# Default value for :format is :airbrussh.
# set :format, :airbrussh

#after 'deploy:updated', 'symfony:assets:install'
#before 'deploy:updated', 'symfony:build_bootstrap'

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

require "dotenv"

# config valid only for current version of Capistrano
lock "3.6.1"

Dotenv.load

set :application, "cardistryio"
set :repo_url, "git@github.com:davidpdrsn/CardistryIO.git"

set :deploy_to, "/home/cardistryio/cardistryio"

set :linked_files, %w{.env config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :conditionally_migrate, true

set :rbenv_type, :system
set :rbenv_path, "/home/cardistryio/.rbenv"
set :rbenv_ruby, File.read(".ruby-version").strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :rollbar_token, ENV.fetch("ROLLBAR_ACCESS_TOKEN")
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, "deploy:restart"
  after :finishing, "deploy:cleanup"
  after :deploy, "resque:restart"
end

namespace :resque do
  task :restart do
    on roles(:app) do
      execute "sudo restart resque"
    end
  end

  task :start do
    on roles(:app) do
      execute "sudo start resque"
    end
  end

  task :stop do
    on roles(:app) do
      execute "sudo stop resque"
    end
  end

  task :status do
    on roles(:app) do
      execute "status resque"
    end
  end
end

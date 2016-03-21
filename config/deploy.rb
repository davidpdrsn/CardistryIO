# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "cardistryio"
set :repo_url, "git@github.com:davidpdrsn/CardistryIO.git"

set :deploy_to, "/home/cardistryio/cardistryio"

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :rbenv_type, :system
set :rbenv_ruby, "2.3.0"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, "deploy:restart"
  after :finishing, "deploy:cleanup"
end

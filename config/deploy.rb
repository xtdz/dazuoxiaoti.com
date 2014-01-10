require "bundler/capistrano"
#require "rvm/capistrano"
#require 'capistrano-rbenv'
#require 'sidekiq/capistrano'

server "110.76.40.35", :web, :app, :db, primary: true

set :application, "dazuoxiaoti"
set :user, "work"
set :deploy_to, "/home/#{user}/rails/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :bundle_flags, '--no-deployment --quiet'
#set :default_shell, '/bin/bash -l'

set :rails_env, "production"
set :rake, "bundle exec rake"
#set :bundle_cmd ,"/home/work/.rbenv/versions/2.0.0-rc2/gemsets/dazuoxiaoti/bin/"
set :bundle_cmd, 'source $HOME/.bashrc && bundle'

set :scm, "git"
set :repository, "git@github.com:shiguodong/dazuoxiaoti.com.git"
set :branch, "master"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
#before 'deploy:setup', 'rvm:install_rvm'




default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :bundle do
    task :install,roles: :app do
      run "cd #{release_path} && bundle install --gemfile #{current_path}/Gemfile  --no-deployment --quiet --without development test"
    end
end





namespace :bundle do
    task :install,roles: :app do
   #   run "cd #{release_path} && bundle install --gemfile #{current_path}/Gemfile  --no-deployment --quiet --without development test"
    end
end


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
     run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
  before "deploy:cold",  "deploy:install_bundler"

  task :install_bundler, :roles => :app do
    run "type -P bundle &>/dev/null || { gem install bundler --no-rdoc --no-ri; }"
   end


  task :migrate,roles: :db do
      run "cd #{current_path} && #{rake} db:mongoid:create_indexes " if exists?(:index)
  end


  task :setup_config, roles: :app do
    #su "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("/home/#{user}/rails/database.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
 # after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/.rbenv-gemsets #{release_path}/.rbenv-gemsets"
    run "ln -nfs #{shared_path}/.ruby-version #{release_path}/.ruby-version"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end


  before "deploy", "deploy:check_revision"

end

#before('bundle:install', 'bundle:prepare')
#after('bundle:install', 'bundle:gemfilelock')
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
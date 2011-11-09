#This file is the capistrano "recipe" where the values needed by cap are defined.

#Default of this is false, so that user bash scripts would be loaded.
# We don't use them, so we set it true
default_run_options[:pty] = true

#This is in another words, the url of the server and port number
set :application, "forester.hficonsultants:3673"

#This is the location of the repository which from we are deploying to server
set :repository,  "git@github.com:michaelleland/Forester.git"

#The value of this variable tells cap what is the version control software in use
set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#This means that we are only deploying CHANGES from github, instead of cloning the WHOLE repo
set deploy_via, :remote_cache

#This sets the branch which is used for deploying
set :branch, "master"

#The authentication information for the remote computer
set :user, "submarine"
set :password, "WwwfiFi'39"
set :scm_passphrase, "WwwfiFi'39"
set :use_sudo, true # We are sudoing so that we have all privileges when deploying

#The folder in the remote computer which to the repo is to be put
set :deploy_to, "/home/submarine/rails/Forester"

ssh_options[:forward_agent] = true

#In this section, multiple servers with different roles could be defined.
# We are using only one server, so these are here just because they are not optional
role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server
role :db,  "#{application}", :primary => true         # This is where Rails migrations will run

#This part is needed for phusion passenger which we are using.
# Basically, the code stops the server, starts it, and touches an empty text file 
# (to determine when all this was done)
namespace :deploy do
  task :start do
    run "/etc/init.d/apache2 start"
  end
   
  task :stop do
    run "/etc/init.d/apache2 stop" 
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
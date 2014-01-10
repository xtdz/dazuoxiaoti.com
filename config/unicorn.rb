root = "/home/www/apps/alumni/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.stderr.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.alumni.sock"
worker_processes 4
timeout 30
#preload_app true
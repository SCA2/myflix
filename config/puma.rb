workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do

  ActiveRecord::Base.establish_connection
  
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
  
  Sidekiq.configure_client do |config|
    config.redis = { size: 1, url: ENV["REDISTOGO_URL"] }
  end

end
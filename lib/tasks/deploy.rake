desc "This task execute all command that is required for successful deployment"
task :deploy do
  puts "Deployment task initiated"

  # Update all resources
  # Rake::Task['auth:update_resources'].invoke

  puts "Deployment task completed"
end

namespace :auth do
  desc "All auth related task"
  task update_resources: :environment do
    puts "Auth update resources task initiated"
    AuthModule::Resources.rebuild_cache
    AuthModule::Permissions.new.refresh
    puts "Auth update resources task completed"
  end
end

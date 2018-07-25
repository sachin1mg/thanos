# Include all ext files
Dir.glob("#{Rails.root}/lib/ext/**/*.rb").each do |file|
  require file
end

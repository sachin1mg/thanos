#Paperclip.options[:command_path] = "/usr/local/bin/"
#
#Paperclip::Attachment.default_options.merge!(
#  storage: :s3,
#  s3_host_name: Settings.AWS.S3.HOST_NAME,
#  bucket: Settings.AWS.S3.BUCKET,
#  s3_region: Settings.AWS.REGION,
#  s3_headers: {
#    "Expires": (Time.zone.now + 10 * 12 * 30 * 24 * 3600).httpdate,
#    "Cache-Control": "max-age = #{10 * 12 * 30 * 24 * 3600}" # 10 years
#  }
#)
#
#Paperclip.interpolates :env do |attachment, style|
#  Rails.env
#End

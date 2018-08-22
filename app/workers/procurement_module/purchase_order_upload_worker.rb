module ProcurementModule
  class PurchaseOrderUploadWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'critical'

    #
    # @user_id [Integer] Required
    # @file [String] file path
    #
    def perform(user_id, file_path, raise_error)
      user = User.find(user_id)
      file = CSV.open(File.expand_path(file_path, Rails.root))

      ProcurementModule::PurchaseOrderUploader.new(user: user, file: file, raise_error: raise_error).upload
      file.close
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
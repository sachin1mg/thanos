#
# This module enable buffering on resources
#
# @author [rohitjangid]
module Bufferable
  extend ActiveSupport::Concern
  module ClassMethods
    #
    # Implement bulk select with buffer
    # @param batch_size: 50 [type] [description]
    # @param sleep_duration: 0.1 [type] [description]
    #
    def buffer_each(batch_size: 50, sleep_duration: 0.1)
      self.find_in_batches(batch_size: batch_size) do |resources|
        resources.each do |resource|
          yield(resource) if block_given?
        end
        sleep(sleep_duration)
      end
    end

    #
    # Implement bulk import with buffer
    # @param data [Array]
    # @param batch_size: 50 [type] [description]
    # @param sleep_duration: 0.1 [type] [description]
    #
    def buffer_import(data, batch_size: 50, sleep_duration: 0.1)
      data.each_slice(batch_size) do |attributes|
        self.import(attributes, *args)
        sleep(sleep_duration)
      end
    end
  end
end

class ApplicationWorker
  include Sidekiq::Worker

  private

  #
  # Execute given block and run garbage collector in the end
  #
  def uncached
    ActiveRecord::Base.uncached do
      yield
    end
  ensure
    # Ensure that Garbage collector always run
    GC.start
  end
end

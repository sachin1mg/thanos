class ApplicationWorker
  include Sidekiq::Worker

  private

  #
  # Execute given block and run garbage collector in the end
  #
  def with_garbage_collection
    yield
  ensure
    # Ensure that Garbage collector always run
    GC.start
  end
end

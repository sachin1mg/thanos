# Global cache redis object
$cache_redis = Redis::Namespace.new(Rails.application.class.parent_name.underscore,
                                    redis: Redis.new(host: Settings.CACHE.REDIS.HOST, port: Settings.CACHE.REDIS.PORT)
                                    )

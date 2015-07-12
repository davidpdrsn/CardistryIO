require "rack-mini-profiler"

Rack::MiniProfilerRails.initialize!(Rails.application)

if Rails.env.production?
  Rails.application.middleware.delete(Rack::MiniProfiler)
  Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
end

desc 'fall back scheduled show times for DST'
task :dst_fallback do
  DstFallBackWorker.perform_now
end

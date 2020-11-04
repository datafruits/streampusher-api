desc 'fall forward scheduled show times for DST'
task :dst_fallforward do
  DstFallForwardWorker.perform_now
end

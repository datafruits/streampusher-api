class EndShrimpoWorker < ActiveJob::base
  queue_as :default

  def perform shrimpo_id
    shrimpo = Shrimpo.find shrimpo_id
    shrimpo.voting!
  end
end

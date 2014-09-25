class Radio < ActiveRecord::Base
  after_create :boot_radio

  def boot_radio
    container_id = RadioBooter.perform_async
    self.update docker_container_id: container_id
  end
end

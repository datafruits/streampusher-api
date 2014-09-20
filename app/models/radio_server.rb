class RadioServer < ActiveRecord::Base
  def boot_radio
    container = Docker::Container.create( 'Image' => 'radio', 'ExposedPorts' => ["8000/tcp"] )
    container.start("PortBindings" => { "8000/tcp" => ["HostPort"=>8000 ] })
  end
end

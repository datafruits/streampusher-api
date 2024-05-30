ActiveSupport.on_load(:action_controller) do
  require 'active_model_serializers/register_jsonapi_renderer'
end

ActiveModelSerializers.config.adapter = :json_api # Default: `:attributes`

ActiveModelSerializers.config.key_transform = :unaltered

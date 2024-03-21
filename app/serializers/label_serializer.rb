class LabelSerializer
  include JSONAPI::Serializer

  attributes :id, :name
end

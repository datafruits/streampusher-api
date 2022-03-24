class RecordingSerializer < ActiveModel::Serializer
  attributes :id, :path, :filesize, :processing_status

  def filesize
    object.filesize
  end
end

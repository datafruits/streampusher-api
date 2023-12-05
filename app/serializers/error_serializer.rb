module ErrorSerializer

  def ErrorSerializer.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |k, v|
      { k.to_sym => v }
    end
    json[:errors] = new_hash
    json
  end
end

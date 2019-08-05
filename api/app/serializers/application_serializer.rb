class ApplicationSerializer < ActiveModel::Serializer
  def json_key
    'data'
  end

  def responds_to?(field)
    object.respond_to?(field) && object.send(field) != nil
  end

  def should_include?(attribute)
    @instance_options[:includes]&.include?(attribute)
  end
end

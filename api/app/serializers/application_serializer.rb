class ApplicationSerializer < ActiveModel::Serializer
  delegate :superadmin?,      to: :current_user
  delegate :admin?,           to: :current_user

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

module IncludeParams
  def parse_include_params(*valid_include_params)
    return [] unless params[:include]

    include_params = params[:include].split(',').map(&:to_sym)
    rest = include_params - valid_include_params

    if rest.length > 0
      raise Errors::BadRequest.new(I18n.t('api.errors.invalid_include_attributes'))
    end

    include_params
  end
end

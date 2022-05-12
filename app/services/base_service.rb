class BaseService
  class CustomErrorHandling < StandardError; end

  def array_contain_all?(arr, arr_other)
    return false unless arr && arr_other

    (arr_other - arr).empty?
  end

  def mapping_attributes(params, mappers)
    attributes = {}
    mappers.with_indifferent_access.each do |name, attribute|
      keys = attribute["field"].split(".")
      value = params.dig(*keys)
      is_array = attribute["is_array"]
      if is_array && !value.is_a?(Array)
        value = [value]
      end

      attributes[name.to_s] = value
    end

    attributes.with_indifferent_access
  end
end

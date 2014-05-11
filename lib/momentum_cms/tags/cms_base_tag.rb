class BaseTag < Liquid::Tag
  def sanatize_params(params)
    params = params.squeeze
    params = params.strip
    params
  end

  def parse_params(params)
    result = {}
    params.split(' ').each do |keyval|
      keyval = keyval.split(':')
      result[keyval[0].to_sym] = keyval[1]
    end
    result
  end
end
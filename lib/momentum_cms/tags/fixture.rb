class FixtureBlockTag < Liquid::Block

  attr_accessor :params

  def initialize(tag_name, params, tokens)
    super
    @params = sanatize_params(params)
    @params = parse_params(params)
  end

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

Liquid::Template.register_tag 'fixture', FixtureBlockTag
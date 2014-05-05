require 'liquid'
require 'yaml'
class ContentTag < Liquid::Tag
  # include LiquidExtensions::Helpers


  def initialize(name, params, tokens)
    # puts name.inspect
    puts params.inspect
    # puts tokens.inspect
  end

  def render(context)
    puts context.environments.to_yaml


    'SUP?'
  end

end


Liquid::Template.register_tag 'content', ContentTag


file      = File.open('layout.liquid', 'r')
liquid    = file.read
@template = Liquid::Template.parse(liquid)


puts @template.render(:bar => 'foo', :baz => 'something')




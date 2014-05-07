require 'liquid'
require 'yaml'

class MomentumCmsTag < Liquid::Tag
  @@registered = Hash.new

  def self.register(tag, klass)
    @@registered[tag] = klass
  end

  def self.new(*args)
    tag = args[1].strip
    o   = if @@registered.has_key?(tag)
            @@registered[tag]
          else
            nil
          end
    raise "Unknown tag #{tag}" if o.nil?
    o = o.allocate
    o.send :initialize, *args
    o
  end
end

class YieldTag < Liquid::Tag
  def initialize(name, params, tokens)
    puts params.inspect
  end

  def render(context)
    _yield = context.environments.first
    _yield =_yield[:yield]
    _yield
  rescue
    ''
  end
end

Liquid::Template.register_tag 'momentum_cms', MomentumCmsTag

MomentumCmsTag.register(':yield', YieldTag)
MomentumCmsTag.register(':hello_world', YieldTag)


file      = File.open('layout.liquid', 'r')
liquid    = file.read
@template = Liquid::Template.parse(liquid)

puts @template.render!(:yield => 'sup yo? yield partial here!')




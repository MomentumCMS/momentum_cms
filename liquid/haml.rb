require 'haml'
puts Haml::Engine.new(::File.open('haml.haml').read).render.rstrip

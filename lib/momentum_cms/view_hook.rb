module MomentumCms
  class ViewHook
    def initialize
      @partials ||= {}
    end

    def partials
      @partials
    end

    def register(name, partial, options = {}, position = nil)
      position = (@partials.length + 1) if position.nil?
      @partials[name] = { partial: partial, options: options, position: position }
    end

    def unregister(name)
      @partials.delete(name)
    end

    def render(template)
      out = ''
      @partials.each do |key, partial|
        out += template.render({ :partial => partial[:partial] }.merge(partial[:options]))
      end
      out.html_safe
    end
  end
end
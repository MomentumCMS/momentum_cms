String.class_eval do
  # Converts string to something suitable to be used as an element id
  def to_slug
    self.strip.gsub(/\W|_/, '-').gsub(/\s|^_*|_*$/, '').squeeze('-').downcase
  end

  def to_cms_object
    /\AMomentumCms::(?<klass>.+)\/\/(?<id>\d+)\z/ =~ self
    return nil if klass.nil? || id.nil?
    [klass, id]
  end
end
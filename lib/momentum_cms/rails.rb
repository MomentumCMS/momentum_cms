String.class_eval do
  # Converts string to something suitable to be used as an element id
  def to_slug
    self.strip.gsub(/\W|_/, '-').gsub(/\s|^_*|_*$/, '').squeeze('-').downcase
  end
end
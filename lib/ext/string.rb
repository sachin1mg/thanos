class String
  #
  # Checks that string is numeric or not.
  #
  def is_integer?
    /\A\d+\z/ === self
  end

  #
  # This function checks that i string have html tag or not.
  # Here we are considering `< ANYTHING >` to be an html tag.
  #
  def html_tag_present?
    self.match(/<\/?(.*?)[^>]*>/).present?
  end
end
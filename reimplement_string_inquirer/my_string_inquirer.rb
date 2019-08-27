class MyStringInquirer < String
  def method_missing(name, *args)
    if name.to_s.end_with?('?')
      self == name.to_s[0..-2]
    else
      super
    end
  end
  
  def respond_to_missing?(name, include_private = false)
    name.to_s.end_with?('?')
  end
end

module MyDynamicFinders
  class RecordNotFound < StandardError; end

  def method_missing(name, *args)
    if respond_to_missing(name)
      name = name.to_s
      querys = querys(name)
      
      arr = $DATABASE.select do |user|
        querys.map.with_index{ |query, i| user.send(query) == args[i] }.all?
      end
      
      raise RecordNotFound if name.end_with?('!') && arr.empty?
      arr.first
    else
      super
    end
  end
  
  def respond_to_missing(name, include_private = false)
    name = name.to_s
    querys = querys(name)

    klass = self
    name.to_s.start_with?('find_by_') && querys.all?{ |query| klass.method_defined?(query) }
  end

  private

  def querys(name)
    temp = name.gsub('find_by_', '')
    (name.end_with?('!') ? temp.tr('!', '') : temp.itself).split('_and_')
  end
end

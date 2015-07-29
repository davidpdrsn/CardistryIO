class CompositeObserver
  pattr_initialize :observers

  def method_missing(name, *args, &block)
    observers.each do |observer|
      observer.public_send(name, *args, &block)
    end
  end

  def respond_to_missing(name, include_private = false)
    if observers.empty?
      false
    else
      observers.first.respond_to?(name)
    end
  end
end

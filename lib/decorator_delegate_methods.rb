module DecoratorDelegateMethods
  def use(klass, options)
    method_name = options.fetch(:for)
    define_method(method_name) do
      klass.new(self).send(method_name)
    end
  end
end

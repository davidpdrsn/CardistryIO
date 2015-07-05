# Class for currying the creation of a decorator
# Useful for making decorators with prespecified dependencies
class CurriedDecorator
  def initialize(decorator, *curried_ags)
    @decorator = decorator
    @curried_ags = curried_ags
  end

  def new(*args)
    @decorator.new(*args.concat(@curried_ags))
  end
end

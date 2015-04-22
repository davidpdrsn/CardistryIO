class DecoratedCollection
  include Enumerable

  def initialize(objects, decorator)
    @objects = objects
    @decorator = decorator
  end

  delegate :present?, to: :objects

  def each(&block)
    decorated_objects.each(&block)
  end

  private

  attr_reader :objects

  def decorated_objects
    @decorated_objects ||= @objects.map { |object| @decorator.new(object) }
  end
end

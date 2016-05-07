class CollectionWithName
  def initialize(name:, collection:)
    @name = name
    @collection = collection
  end

  include Enumerable

  def type_name
    name
  end

  def each(&block)
    collection.each(&block)
  end

  def has_results?
    collection.present?
  end

  private

  attr_reader :name, :collection
end

class CompositeRelation < BasicObject
  def initialize(relations)
    @relations = relations
  end

  def method_missing(name, *args, &block)
    composite.send(name, *args, &block)
  end

  private

  def composite
    @composite ||= begin
                     @relations.reduce do |acc, relation|
                       acc.merge(relation)
                     end
                   end
  end
end

class DelegationChain
  def initialize(*objs)
    @objs = objs
  end

  def method_missing(name, *args, &block)
    first_responder(name).send(name, *args, &block)
  end

  def respond_to_missing?(name, include_private = false)
    first_responder(name).present?
  end

  def to_param
    first_responder(:to_param).to_param
  end

  private

  attr_reader :objs

  def first_responder(name)
    objs.detect { |obj| obj.respond_to?(name) }
  end
end

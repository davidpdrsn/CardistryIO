class ActiveRecordDecorator < SimpleDelegator
  def class
    __getobj__.class
  end

  def is_a?(klass)
    __getobj__.is_a?(klass)
  end
end

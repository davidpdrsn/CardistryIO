class ObservableRecord < SimpleDelegator
  def initialize(model, observer)
    super(model)
    @model = model
    @observer = observer
  end

  def save
    track_method(:save)
  end

  def save!
    track_method(:save!)
  end

  def update(params)
    track_method(:update, params)
  end

  def update!(params)
    track_method(:update!, params)
  end

  def class
    model.class
  end

  def is_a?(klass)
    model.class == klass
  end

  private

  attr_reader :model, :observer

  def track_method(name, *args)
    save_worked = model.send(name, *args)
    if save_worked
      all_args = [model] + args
      observer.send(name, *all_args)
    end
    save_worked
  end
end

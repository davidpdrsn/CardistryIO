require "rails_helper"

describe ObservableRecord do
  it "saves the model" do
    observer = double("observer")
    model = double("model", save: true)
    allow(observer).to receive(:save).with(model)

    record = ObservableRecord.new(model, observer)
    record.save

    expect(model).to have_received(:save)
  end

  it "notifies an observer when the model is saved" do
    observer = double("observer")
    model = double("model", save: true)
    allow(observer).to receive(:save).with(model)

    record = ObservableRecord.new(model, observer)
    record.save

    expect(model).to have_received(:save)
    expect(observer).to have_received(:save).with(model)
  end

  it "doesn't notify the observer if the save fails" do
    observer = double("observer")
    model = double("model", save: false)
    allow(observer).to receive(:save).with(model)

    record = ObservableRecord.new(model, observer)
    record.save

    expect(observer).not_to have_received(:save).with(model)
  end

  it "updates the model" do
    observer = double("observer")
    model = double("model", update: true)
    params = { name: "bob" }
    allow(observer).to receive(:update).with(model, params)

    record = ObservableRecord.new(model, observer)
    record.update(params)

    expect(model).to have_received(:update).with(params)
  end

  it "notifies an observer when the model is updated" do
    observer = double("observer")
    model = double("model", update: true)
    params = { name: "bob" }
    allow(observer).to receive(:update).with(model, params)

    record = ObservableRecord.new(model, observer)
    record.update(params)

    expect(observer).to have_received(:update).with(model, params)
  end

  it "doesn't notify the observer if the update failed" do
    observer = double("observer")
    model = double("model", update: false)
    params = { name: "bob" }
    allow(observer).to receive(:update).with(model, params)

    record = ObservableRecord.new(model, observer)
    record.update(params)

    expect(observer).not_to have_received(:update).with(model, params)
  end

  it "delegates #class to the model" do
    probe = double("probe")
    model = double("model", class: probe)
    observer = double("observer")
    record = ObservableRecord.new(model, observer)

    expect(record.class).to eq probe
  end

  it "delegates #is_a? to the model" do
    probe = double("probe")
    observer = double("observer")
    record = ObservableRecord.new(
      double("record", class: probe),
      observer
    )
    another_record = ObservableRecord.new(
      double("record", class: probe),
      observer
    )

    expect(record.is_a?(another_record.class)).to eq true
  end

  describe "bang methods" do
    it "saves the model" do
      observer = double("observer")
      model = double("model", save!: true)
      allow(observer).to receive(:save!).with(model)

      record = ObservableRecord.new(model, observer)
      record.save!

      expect(observer).to have_received(:save!)
    end

    it "updates the model" do
      observer = double("observer")
      model = double("model", update!: true)
      params = { name: "bob" }
      allow(observer).to receive(:update!).with(model, params)

      record = ObservableRecord.new(model, observer)
      record.update!(params)

      expect(observer).to have_received(:update!).with(model, params)
    end
  end
end

module PolymorphicAssociationValidator
  def self.new(name:, types:)
    Class.new(ActiveModel::Validator) do
      define_method(:validate) do |record|
        return if record.public_send(name).class.in?(types)
        record.errors.add(name, "of this type not supported")
      end
    end
  end
end

module PolymorphicAssociationForEnumValuesValidator
  def self.new(name:, enum_column:, types:)
    Class.new(ActiveModel::Validator) do
      define_method(:validate) do |record|
        allowed_subject_types = types[record.send(enum_column)]
        associated_record = record.send(name)

        if associated_record.present? && !associated_record.class.in?(allowed_subject_types)
          message = allowed_subject_types.map(&:name).map(&:downcase).join(", ")
          record.errors.add(
            name,
            "is the wrong type. Only #{message} is allowed for #{record.send(enum_column)}. Not #{associated_record.class}",
          )
        end
      end
    end
  end
end

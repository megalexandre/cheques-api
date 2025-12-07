module ValidatesFieldFormat
  extend ActiveSupport::Concern

  class_methods do
    def validates_date_format(field_name)
      validate :"validate_#{field_name}_format"

      define_method :"validate_#{field_name}_format" do
        raw_value = instance_variable_get("@raw_#{field_name}")

        return if raw_value.blank?
        return if valid_date?(raw_value)

        errors.add(field_name, "is not a valid date")
      end
    end

    def validates_integer_format(field_name)
      validate :"validate_#{field_name}_format"

      define_method :"validate_#{field_name}_format" do
        raw_value = instance_variable_get("@raw_#{field_name}")

        return if raw_value.blank?
        return if valid_integer?(raw_value)

        errors.add(field_name, "is not a number")
      end
    end
  end

  private

  def valid_date?(value)
    return true if value.is_a?(Date) || value.is_a?(Time) || value.is_a?(DateTime)
    return false unless value.is_a?(String)

    Date.parse(value)
    true
  rescue ArgumentError, TypeError
    false
  end

  def valid_integer?(value)
    return true if value.is_a?(Integer)
    return false unless value.is_a?(String)

    # Verifica se é uma string numérica válida (aceita negativos)
    value.match?(/\A-?\d+\z/)
  end
end

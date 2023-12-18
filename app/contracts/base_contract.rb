class BaseContract < Dry::Validation::Contract
  def self.errors_to_a(contract)
    contract.errors.to_h.map { |key, values| values.map { |value| "#{key} #{value}" } }.flatten
  end
end

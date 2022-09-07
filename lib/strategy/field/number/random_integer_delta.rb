module DataAnon
  module Strategy
    module Field

      # Shifts the current value randomly within given delta + and -. Default is 10
      #
      #    !!!ruby
      #    anonymize('Age').using FieldStrategy::RandomIntegerDelta.new(2)

      class RandomIntegerDelta

        def initialize delta = 10
          @delta = delta
        end

        def anonymize field
          adjustment = DataAnon::Utils::RandomInt.generate(-@delta,@delta)
          value = field.value
          value = field.value.first if field.value.is_a? Array
          value = value.to_i if field.value.is_a? String
          value = 0 if value == nil
          return value + adjustment
        end
      end

    end
  end
end

module DataAnon
  module Strategy
    module Field

      # Generates random name prefix
      #
      #    !!!ruby
      #    anonymize('prefix').using FieldStrategy::RandomPrefix.new

      class RandomPrefix

        def initialize
          @prefixes = %w{Mr. Mrs. Ms. Miss. Dr.}
        end

        def anonymize field
          @prefixes[(rand() * @prefixes.length).to_i]
        end

      end


    end
  end
end

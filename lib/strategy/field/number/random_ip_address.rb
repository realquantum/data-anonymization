require 'faker'

module DataAnon
  module Strategy
    module Field

      # Generates random ip address
      #
      #    !!!ruby
      #    anonymize('Age').using FieldStrategy::RandomIpAddress.new

      class RandomIpAddresss

        def initialize
        end

        def anonymize field
          Faker::Internet.ip_v4_address
        end

      end


    end
  end
end

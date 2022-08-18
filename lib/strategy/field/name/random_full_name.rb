module DataAnon
  module Strategy
    module Field

      # Generates full name using the RandomFirstName and RandomLastName strategies.
      #
      #    !!!ruby
      #    anonymize('FullName').using FieldStrategy::RandomFullName.new
      #
      #    !!!ruby
      #    anonymize('FullName').using FieldStrategy::RandomLastName.new('my_first_names.txt', 'my_last_names.txt')

      class RandomFullName

        def initialize first_names = nil, last_names = nil
          @first_name_anonymizer = DataAnon::Strategy::Field::RandomFirstName.new(first_names)
          @last_name_anonymizer = DataAnon::Strategy::Field::RandomLastName.new(last_names)
        end

        def anonymize field

          name_words = field.value.split(/\s+/)

          anonymized_first_name = @first_name_anonymizer.anonymize(field)
          anonymized_first_name = anonymized_first_name[0] if anonymized_first_name.is_a? Array
          anonymized_last_name = ""
          counter = 1
          while counter < name_words.length
            counter += 1
            name = @last_name_anonymizer.anonymize(field)
            name = name[0] if name.is_a? Array
            anonymized_last_name = anonymized_last_name + " " + name
          end
          return anonymized_first_name + anonymized_last_name

        end
      end
    end
  end
end

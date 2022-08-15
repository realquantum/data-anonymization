module DataAnon
  module Strategy
    module Field

      # Similar to SelectFromList with difference is the list of values are collected from the database table using distinct column query.
      #
      #    !!!ruby
      #    # values are collected using `select distinct state from customers` query connecting to specified database in connection_spec
      #    anonymize('state').using FieldStrategy::FuzzyAddress.new('customers',map, connection_spec)

      class FuzzyAddress < PostgisBase
        include Utils::Logging

        def initialize table_name, map
          @table_name = table_name
          @map = map
        end

        def anonymize field
          #@values ||= begin
          #DataAnon::Utils::SourceDatabase.establish_connection @connection_spec
          #source = Utils::SourceTable.create @table_name, []
          #values = source.select(@field_name).distinct.collect { |record| record[@field_name]}
          logger.debug "For field strategy #{@table_name}:#{@map.inspect} using values  "
          #values
          # end
          #super
          []
        end
      end
    end
  end
end

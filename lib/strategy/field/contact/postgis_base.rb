module DataAnon
  module Strategy
    module Field
      class PostgisBase

        def initialize dhb
          @dbh = dbh
        end

        def anonymize field
          STDERR.puts "POSTGIS: #{field.inspect}"
        end
      end
    end
  end
end

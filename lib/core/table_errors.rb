module DataAnon
  module Core

    class TableErrors
      include Utils::Logging

      def initialize table_name
        @table_name = table_name
        @errors = []
      end

      def log_error record, exception
        if exception.to_s =~ /NotNullViolation/
          record.delete
          return
        end
        @errors << { :record => record, :exception => exception}
        if @errors.length > 1
          p ["ERRORS", @errors]
          raise 'Reached limit of error for a table' 
          exit
        end
      end

      def errors
        @errors
      end

      def print
        return if @errors.length == 0
        logger.error("Errors while processing table '#{@table_name}':")
        @errors.each do |error|
          logger.error(error[:exception])
          logger.error(error[:exception].backtrace.join("\n\t"))
        end
      end

    end

  end
end

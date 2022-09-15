require 'faker'
require 'nokogiri'

module DataAnon
  module Strategy
    module Field

      # Default anonymization strategy for `string` content. Uses default 'Lorem ipsum...' text or text supplied in strategy to generate same length string.
      #    !!!ruby
      #    anonymize('HtmlEditor').using FieldStrategy::LoremIpsumHtml.new
      #
      #    !!!ruby
      #    anonymize('HtmlEditor').using FieldStrategy::LoremIpsumHtml.new("<p>very large string....</p>")
      #
      #    !!!ruby
      #    anonymize('HtmlEditor').using FieldStrategy::LoremIpsumHtml.new(File.read('my_file.html'))

      class LoremIpsumHtml

        def initialize text = nil
          @text = text || ''
        end

        def anonymize field
          if field.value.length > 8
            nok = Nokogiri::HTML.fragment( field.value )
            nbsp = Nokogiri::HTML.fragment("&nbsp;").text
            # STDERR.puts "1" if $should_print == true
            nok.xpath('.//text() | text()').each do |x|
              if x.content =~ /#{nbsp}/
                # Preserve non-breaking spaces for proper alignment of lipsum.
                parts = []
                # STDERR.puts "6" if $should_print == true
                x.content.split(/(\s*#{nbsp}\s*)/).each do |part|
                  if part =~ /#{nbsp}/
                    parts.push part
                  else
                    parts.push Faker::Lorem.paragraph_by_chars(number: part.length)
                  end
                end
                x.content = parts.join("")
              else
                unless x.content =~ /^\s*$/
                  # STDERR.puts "7" if $should_print == true
                  x.content = Faker::Lorem.paragraph_by_chars(number: x.content.length)
                end
              end
            end
            nok.xpath('.//img').each do |x|
              if x.attr('width') and x.attr('height')
                # STDERR.puts "3" if $should_print == true
                x.set_attribute('src', Faker::LoremFlickr.image(size: "#{x.attr('width')}x#{x.attr('height')}", search_terms: ['building']))
              else
                # STDERR.puts "4" if $should_print == true
                x.set_attribute('src', Faker::LoremFlickr.image(search_terms: ['building']))
              end
            end
            nok.xpath('.//a').each do |x|
              # STDERR.puts "5" if $should_print == true
              x.set_attribute('href', '#')
            end
            return nok.to_html.gsub(/#{nbsp}/, '&nbsp;')
          end
        end
      end

    end
  end
end

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
            nok.traverse do |x|
              if x.name == 'img'
                # Change Images to LoremFlickr
                if x.attr('width') and x.attr('height')
                  x.set_attribute('src', Faker::LoremFlickr.image(size: "#{x.attr('width')}x#{x.attr('height')}", search_terms: ['building']))
                else
                  x.set_attribute('src', Faker::LoremFlickr.image(search_terms: ['building']))
                end
              elsif x.name == 'a'
                # Remove HREFs
                x.set_attribute('href', '#')
              elsif x.text? and x.content =~ /^(?:\s*#{nbsp}\s*)+$/
                # Skip empty tags and whitespace
              elsif x.text? and not x.content =~ /^\s*$/
                if x.content =~ /#{nbsp}/
                  # Preserve non-breaking spaces for proper alignment of lipsum.
                  parts = []
                  x.content.split(/(\s*#{nbsp}\s*)/).each do |part|
                    if part =~ /#{nbsp}/
                      parts.push part
                    else
                      parts.push Faker::Lorem.paragraph_by_chars(number: part.length)
                    end
                  end
                  x.content = parts.join("")
                else
                  x.content = Faker::Lorem.paragraph_by_chars(number: x.content.length)
                end
              end
            end
            return nok.to_html.gsub(/#{nbsp}/, '&nbsp;')
          else
            return Faker::Lorem.paragraph_by_chars(number: field.value.length)
          end
        end
      end

    end
  end
end

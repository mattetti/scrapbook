module Scrapbook
  module Utils

    module Fetcher
      def fetch(element, selector, modifier)
        begin
          modifier.call element.search(selector)
        rescue Exception => e
          failure = "#{e.inspect} while fetching '#{selector}' on \n#{element}\n-backtrace: #{caller[0..4].join("\n")}\n---\n"
          @failures ||= []
          @failures << failure
          nil
        end
      end
    end

  end
end

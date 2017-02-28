module Jaly
  module MultiSupport
    class << self
      @@loaders = []
      @@search_engines = []

      def add_loader(klass)
        @@loaders << klass
        true
      end

      def add_search_engine(klass)
        @@search_engines << klass
        true
      end

      def load_from_uri(uri)
        result = nil
        @@loaders.each do |loader_class|
          break if result = loader_class.generate_from_uri(uri)
        end
        result
      end
    end
  end
end

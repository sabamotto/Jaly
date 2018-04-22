module Jaly
  module SearchEngine
    class Base
      # incomp

      @@name = 'unknown'
      def self.provider
        @@name
      end

      protected

      def self.set_provider(name)
        @@name = name
      end
    end
  end
end

module Jaly
  class << self
    def load(uri)
      MultiSupport.load_from_uri(uri)
    end
  end
end

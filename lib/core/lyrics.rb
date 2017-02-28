module Jaly
  class Lyrics
    attr_reader :loader

    attr_accessor :title

    attr_reader :uri
    attr_reader :meta

    def initialize(loader, uri)
      @loader = loader
      @uri = uri
      @data = []
      @meta = {
        artist: nil,
        songwriter: nil,
        composer: nil,
        arranger: nil,
        genre: '',
        spelling: nil,
      }
    end

    def clear
      @data = [] if @data.any?
    end

    def <<(line)
      @data << unify_line(line)
    end
    def [](index)
      @data[index]
    end
    def []=(index, line)
      @data[index] = unify_line(line)
    end

    def text
      result = ''
      @data.each do |line|
        result << (line.is_a?(String) ? line : line[:text] || '')
        result << "\n"
      end
      result
    end

    def empty?
      @data.empty?
    end

    private

    def unify_line(line)
      case line
      when Hash
        line
      when String
        {text: line}
      else
        {}
      end
    end
  end
end

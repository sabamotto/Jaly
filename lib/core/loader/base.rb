module Jaly
  module Loader
    class Base
      def initialize(base_uri=nil)
        @lyrics = create_lyrics(base_uri) if base_uri
      end

      def load(uri)
        @lyrics = create_lyrics(uri)
      end

      def lyrics
        if @lyrics.empty?
          charset = nil
          html = open(@lyrics.uri) do |f|
            charset = f.charset
            f.read
          end

          self.class.parse(@lyrics, html, charset: charset)
        end

        @lyrics
      end

      def self.parse(lyrics, object, opts=nil)
        raise 'loader class parser is not implemented'
      end

      @@uri_patterns = -> (uri) {
        raise 'loader class URI matcher is not implemented'
      }
      def self.generate_from_uri(uri)
        result = nil
        if @@uri_patterns.is_a?(Proc)
          if @@uri_patterns.call
            result = self.new(uri)
          end
        else
          @@uri_patterns.each do |pattern|
            if uri =~ pattern
              result = self.new(uri)
              break
            end
          end
        end
        result
      end


      protected

      def create_lyrics(base_uri)
        Lyrics.new(self, base_uri)
      end

      def self.simple_parse_html_element(lyrics, lyrics_elem)
        lyrics.clear
        line = {}
        lyrics_elem.children.each do |node|
          if node.text?
            if line[:text]
              line[:text] << node.content.strip
            else
              line[:text] = node.content.strip
            end
          elsif node.elem? and node.name.downcase == 'br'
            lyrics << line
            line = {}
          elsif block_given?
            yield line, node
          end
        end
        if line[:text] and line[:text].size > 0
          lyrics << line
        end
        lyrics
      end

      @@multi_supported = nil
      def self.uri_matching(obj)
        unless @@multi_supported
          @@multi_supported = MultiSupport.add_loader(self)
        end

        case obj
        when Proc
          @@uri_patterns = obj
        when Regexp
          @@uri_patterns = [] if @@uri_patterns.is_a? Proc
          @@uri_patterns << obj
        when String
          @@uri_patterns = [] if @@uri_patterns.is_a? Proc
          @@uri_patterns << Regexp.new(
            "\\Ahttps?:\/\/#{obj.gsub(/\.|\//, '\\0')}"
          )
        else
          raise 'illegal object'
        end
      end

      @@name = 'unknown'
      def self.provider
        @@name
      end
      def self.set_provider(name)
        @@name = name
      end
    end
  end
end

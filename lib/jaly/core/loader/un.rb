module Jaly
  module Loader
    class Un < Base
      set_provider '歌ネット'
      uri_matching 'www.uta-net.com/song/'

      @@meta_relation = {
        '歌手：' => :artist,
        '作詞：' => :songwriter,
        '作曲：' => :composer,
        '編曲：' => :arranger,
      }

      def parse
        @lyrics.clear

        # parse title
        doc = document(@lyrics.uri, 'CP932')
        view = doc.at_css('#view_kashi')
        @lyrics.title = view.at_css('h2').inner_text.strip

        # parse meta data
        meta_key = nil
        view.at_css('.kashi_artist').children.each do |node|
          if node.text?
            meta_key = @@meta_relation[node.text.strip]
          elsif node.elem? and meta_key and node.name.downcase =~ /h\d/
            @lyrics.meta[meta_key] = node.inner_text.strip
          end
        end

        if elem = view.at_css('#kashi_area')
          # parse lyrics field
          simple_parse_html_element elem

        elsif elem = view.at_css('#ipad_kashi img')
          # parse lyrics from SVG
          doc = document("http://www.uta-net.com/#{elem.attribute('src')}")
          doc.css('text').each do |line|
            @lyrics << line.inner_text.strip
          end
        end

        @lyrics
      end
    end
  end
end

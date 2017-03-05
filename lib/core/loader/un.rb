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
          puts node.inner_text
          if node.text?
            meta_key = @@meta_relation[node.text.strip]
          elsif node.elem? and meta_key and node.name.downcase =~ /h\d/
            @lyrics.meta[meta_key] = node.inner_text.strip
          end
        end

        # parse lyrics from SVG
        k_uri = view.at_css('#ipad_kashi img')&.attribute('src')
        doc = document("http://www.uta-net.com/#{k_uri}") if k_uri
        doc.css('text').each do |line|
          @lyrics << line.inner_text.strip
        end

        @lyrics
      end
    end
  end
end

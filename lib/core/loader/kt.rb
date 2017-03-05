module Jaly
  module Loader
    class Kt < Base
      set_provider '歌詞タイム'
      uri_matching 'www.kasi-time.com/item-'

      @@meta_relation = {
        '歌手' => :artist,
        '作詞' => :songwriter,
        '作曲' => :composer,
        '編曲' => :arranger,
        'カテゴリ' => :genre,
        '読み' => :spelling,
      }

      def parse
        @lyrics.clear

        doc = document(@lyrics.uri)

        # parse lyrics
        elem = doc.at_css('#lyrics')
        if elem.text.strip.size == 0
          code = doc.at_css('body .center > script')
            .text.match(/var\s+lyrics\s*=\s*'([^']*)';/)
          if code and code[1].size > 0
            elem = Nokogiri::HTML.parse("<div id=lyrics>#{code[1]}</div>").at_css('#lyrics')
          else
            elem = nil
          end
        end
        simple_parse_html_element elem if elem

        # parse title
        @lyrics.title = doc.at_css('.song_info h1').inner_text.strip

        # parse meta data
        doc.at_css('.song_info .person_list > table').children.each do |tr|
          next unless tr.elem? and tr.name.downcase == 'tr'
          if meta_key = @@meta_relation[tr.at_css('th')&.inner_text&.strip]
            @lyrics.meta[meta_key] = tr.at_css('td')&.inner_text&.strip.gsub(/　\z/, '')
          end
        end
        doc.at_css('.song_info .other_list > table').children.each do |tr|
          next unless tr.elem? and tr.name.downcase == 'tr'
          if meta_key = @@meta_relation[tr.at_css('th')&.inner_text&.strip]
            @lyrics.meta[meta_key] = tr.at_css('td')&.inner_text&.strip.gsub(/　\z/, '')
            @lyrics.meta[:genre] = @lyrics.meta[:genre].match(/\A\S*/)[0] if meta_key == :genre
          end
        end

        @lyrics
      end
    end
  end
end

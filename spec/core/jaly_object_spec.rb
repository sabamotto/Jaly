require "spec_helper"

describe Jaly do
  describe "Lyrics" do
    let(:lyrics) { Jaly::Lyrics.new(nil, nil) }

    it "is empty after created" do
      expect(lyrics.empty?).to eq(true)
    end

    describe "line data" do
      it "should be Hash object if you add string data" do
        lyrics << 'test-line1'
        lyrics[1] = 'test-line2'
        expect(lyrics[0]&.fetch(:text)).to eq('test-line1')
        expect(lyrics[1]&.fetch(:text)).to eq('test-line2')
      end
    end
  end
end

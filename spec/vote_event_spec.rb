require './lib/scrapper'
require 'pupa'
require 'nokogiri'


describe CLVoteScrapper, "#get" do

  before(:all) do
    $raw_info = Nokogiri.XML(File.open("./spec/8575.xml", 'rb'))
  end
  context "Vote Events" do
    it "selects vote events" do
      scrapper = CLVoteScrapper.new
      scrapper.read($raw_info)
      expect(scrapper.vote_events.length).to eq(7)
    end
    it "it is a pupa processor" do
      scrapper = CLVoteScrapper.new
      expect(scrapper).to be_a(Pupa::Processor)
    end
  end
end

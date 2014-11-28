require './lib/scrapper'
require 'pupa'


describe CLVoteScrapper, "#get" do

  before(:all) do
    $raw_info = ""
    File.open("./spec/8575.xml", "r") do |infile|
      while (line = infile.gets)
        $raw_info += line
      end
    end
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

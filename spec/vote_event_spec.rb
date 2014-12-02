require './lib/scrapper'
require 'pupa'
require 'nokogiri'


describe CLVoteScrapper, "#get" do

  before(:all) do
    $raw_info = Nokogiri.XML(File.open("./spec/8575.xml", 'rb'))
    $motion = Pupa::Motion.new(text: '8575-05')
  end
  context "Vote Events scrapers" do
    it "receives a motion as a parameter" do
      scrapper = CLVoteScrapper.new motion: $motion
      expect(scrapper.motion).to eq($motion)
    end
    it "selects vote events" do
      scrapper = CLVoteScrapper.new motion:$motion
      scrapper.read($raw_info)
      expect(scrapper.vote_events.length).to eq(11)
    end
    it "it is a pupa processor" do
      scrapper = CLVoteScrapper.new motion:$motion
      expect(scrapper).to be_a(Pupa::Processor)
    end
    it "collect the voting events" do
      scrapper = CLVoteScrapper.new motion:$motion
      scrapper.read($raw_info)
      expect(scrapper.vote_events[0]).to be_a(Pupa::VoteEvent)
    end
    # it "collects the right information about the event" do
    #   scrapper = CLVoteScrapper.new
    #   scrapper.read($raw_info)
    #   vote_event = scrapper.vote_event[0]
    # end
  end
end

require 'pupa'
require './lib/person_scrapper'
require 'htmlentities'


describe PersonScraper , "#initialize" do
  context "initialization" do
    it "is a kind of Pupa::Processor" do
      scrapper = PersonScraper.new './results'
      expect(scrapper).to be_a Pupa::Processor
    end
  end
end
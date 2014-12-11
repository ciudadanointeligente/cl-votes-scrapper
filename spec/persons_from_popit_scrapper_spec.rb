require 'pupa'
require './lib/person_scrapper'
require 'htmlentities'
require 'json'
require 'open-uri'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => /popoloproject.com/)
describe PersonScraper , "The person Scrapper" do
  def connection
    Pupa::Processor::Connection::MongoDBAdapter.new('mongodb://localhost:27017/pupa')
  end
  context "initialization" do
    it "is a kind of Pupa::Processor" do
      scrapper = PersonScraper.new './results'
      expect(scrapper).to be_a Pupa::Processor
    end
  end
  context "scrapping objects" do 
  	before :all do
      
  		$file = File.read('./spec/congressmen.json')
  		$persons_json = JSON.parse($file)
  		$scrapper = PersonScraper.new "results"
      PersonScraper.add_scraping_task(:people)
    end
    after :each do
      connection.raw_connection[:people].drop
    end
    it "creates persons from the file" do
      # I'm expecting to have a lot of people stored in my db
      # allow(OpenURI).to receive(:open).and_return("Whatever for now")
      # read.stub(:read).and_return('log-level set to 1')
      # allow($scrapper).to receive(:open).and_return($file)
      stub_request(:any, "http://pmocl.popit.mysociety.org/api/v0.1/persons").to_return(:body => $file)
      runner = Pupa::Runner.new(PersonScraper)
      runner.run([])
      result = connection.find(_type: 'pupa/person', name: 'Jorge Pizarro Soto')
      result.should be_a(Hash)
      
      expect(result["name"]).to eq("Jorge Pizarro Soto")
      expect(result["identifiers"]).to include({"identifier"=>"53303739d0c05d8b737b6ce6"})
      expect(result["other_names"]).to include({'name'=>'Pizarro S., Jorge', "note"=>"For voting"})
      

  	end
  end
end
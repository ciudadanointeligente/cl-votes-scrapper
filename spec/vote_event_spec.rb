require './lib/scrapper'
require './lib/models/vote_event'
require 'pupa'
require 'nokogiri'


describe Votacion , "#initialize" do
  context "initialization" do
    it "is a kind of Pupa::Model" do
      votacion = Votacion.new 
      expect(votacion).to be_a Pupa::Model
    end
  end
end
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
    it "collects the right information about the motion id" do
      scrapper = CLVoteScrapper.new motion:$motion
      scrapper.read($raw_info)
      vote_event = scrapper.vote_events[0]
      expect(vote_event.motion_id).to eq($motion._id)
    end
    it "collects extra information" do
      scrapper = CLVoteScrapper.new motion:$motion
      scrapper.read($raw_info)
      vote_event = scrapper.vote_events[0]
      expect(vote_event.tema).to eq("Rechazo letra a) Indicación N°62  , Partida 10 Ministerio de Justicia (Boletín N°8.575-05) Proyecto de Ley de Presupuestos.")
      expect(vote_event.created_at).to eq(Date.new(2012,11,23))
      expect(vote_event.quorum).to eq("Mayoría simple")
      expect(vote_event.tipo_votacion).to eq("Discusión única")
      expect(vote_event.sesion).to eq("73/360")
      expect(vote_event.etapa).to eq("Segundo trámite constitucional")
    end
    it "uses the information to dump data" do
      scrapper = CLVoteScrapper.new motion:$motion
      scrapper.read($raw_info)
      vote_event = scrapper.vote_events[0]
      hash = vote_event.to_h

      expect(hash[:tema]).to eq("Rechazo letra a) Indicación N°62  , Partida 10 Ministerio de Justicia (Boletín N°8.575-05) Proyecto de Ley de Presupuestos.")
      expect(hash[:quorum]).to eq("Mayoría simple")
      expect(hash[:tipo_votacion]).to eq("Discusión única")
      expect(hash[:sesion]).to eq("73/360")
      expect(hash[:etapa]).to eq("Segundo trámite constitucional")
    end
  end
  context "vote event count" do
    before(:all) do
      $raw_info = Nokogiri.XML(File.open("./spec/8575.xml", 'rb'))
      $motion = Pupa::Motion.new(text: '8575-05')
      $scrapper = CLVoteScrapper.new motion:$motion
      $scrapper.read($raw_info)
      $vote_event = $scrapper.vote_events[0]
    end
    it "has a count object" do
      expect($vote_event.counts.length).to be 4
    end
    it "gets the options right" do
      expect($vote_event.counts[0][:option]).to eq "SI"
      expect($vote_event.counts[1][:option]).to eq "NO"
      expect($vote_event.counts[2][:option]).to eq "PAREO"
      expect($vote_event.counts[3][:option]).to eq "ABSTENCION"
    end
    it "gets the values right" do
      # SI
      expect($vote_event.counts[0][:value]).to eq 10
      # NO
      expect($vote_event.counts[1][:value]).to eq 13
      # PAREO
      expect($vote_event.counts[2][:value]).to eq 2
      # ABSTENCION
      expect($vote_event.counts[3][:value]).to eq 1
    end
  end
end

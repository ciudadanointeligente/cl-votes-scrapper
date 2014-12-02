require 'pupa'

class CLVoteScrapper < Pupa::Processor
  attr_accessor :vote_events
  attr_accessor :motion

  def initialize(motion ,*args)
    self.vote_events = []
    self.motion = motion[:motion]
  end

  def read xml
    xml.xpath("votaciones/votacion").each do |event|
      vote_event = Pupa::VoteEvent.new
      vote_event.identifier = event.xpath('SESION/text()')
      self.vote_events << vote_event
    end

  end
end

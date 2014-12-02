require 'pupa'
require './lib/models/vote_event'
require 'htmlentities'

class CLVoteScrapper < Pupa::Processor
  attr_accessor :vote_events
  attr_accessor :motion

  def initialize(motion ,*args)
    self.vote_events = []
    self.motion = motion[:motion]
  end

  def read xml
    xml.xpath("votaciones/votacion").each do |event|
      vote_event = Votacion.new
      # vote_event.identifier = event.xpath('SESION/text()')
      # 
      vote_event.tema = HTMLEntities.new.decode event.xpath('TEMA/text()').to_s
      vote_event.motion_id = motion._id
      self.vote_events << vote_event
    end

  end
end

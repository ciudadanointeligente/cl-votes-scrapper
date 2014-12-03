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
      vote_event.tema = HTMLEntities.new.decode event.xpath('TEMA/text()').to_s
      vote_event.quorum = HTMLEntities.new.decode event.xpath('QUORUM/text()').to_s
      vote_event.created_at = Date.parse event.xpath('FECHA/text()').to_s
      vote_event.tipo_votacion = HTMLEntities.new.decode event.xpath('TIPOVOTACION/text()').to_s
      vote_event.sesion = HTMLEntities.new.decode event.xpath('SESION/text()').to_s
      vote_event.etapa = HTMLEntities.new.decode event.xpath('ETAPA/text()').to_s


      #COUNTS 
      # vote_event.add_count()
      si = HTMLEntities.new.decode event.xpath('SI/text()')
      no = HTMLEntities.new.decode event.xpath('NO/text()')
      pareo = HTMLEntities.new.decode event.xpath('PAREO/text()')
      abstencion = HTMLEntities.new.decode event.xpath('ABSTENCION/text()')

      vote_event.add_count("SI", si.to_i)
      vote_event.add_count("NO", no.to_i)
      vote_event.add_count("PAREO", pareo.to_i)
      vote_event.add_count("ABSTENCION", abstencion.to_i)



      # HEY THIS IS NOT RIGHT
      vote_event.motion_id = motion._id
      self.vote_events << vote_event
    end

  end
end

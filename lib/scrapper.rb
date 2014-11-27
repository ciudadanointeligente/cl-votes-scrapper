require 'pupa'

class CLVoteScrapper < Pupa::Processor
  attr_accessor :vote_events

  def initialize(*args)
    self.vote_events = [1,2,3,4,5,6,7]
  end

  def read xml_string
  end
end

require 'pupa'
require 'open-uri'
require 'json'

class PersonScraper < Pupa::Processor
	def scrape_people
		doc = open('http://pmocl.popit.mysociety.org/api/v0.1/persons').read
		json_response = JSON.parse(doc)
		json_response['result'].each do |person_h|
			person = Pupa::Person.new
			person.name = person_h['name']
			person.add_identifier(person_h['id'])
			person_h['other_names'].each do |other_name|
				person.add_name(other_name['name'], note:other_name['note'])	
			end
			dispatch(person)
		end

	end
end
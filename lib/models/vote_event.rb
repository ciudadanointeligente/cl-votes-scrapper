class Votacion < Pupa::VoteEvent

	foreign_object :motion
	attr_accessor :tema
	attr_accessor :quorum
end
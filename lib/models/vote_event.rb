class Votacion < Pupa::VoteEvent

	foreign_object :motion
	attr_accessor :tema
	attr_accessor :quorum
	attr_accessor :tipo_votacion
	attr_accessor :sesion
	attr_accessor :etapa
end
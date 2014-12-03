class Votacion < Pupa::VoteEvent

	foreign_object :motion
	attr_accessor :tema, :quorum, :tipo_votacion, :sesion, :etapa
	dump :tema, :quorum, :tipo_votacion, :sesion, :etapa
end
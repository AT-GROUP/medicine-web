(define 
	(domain ambulance)
	
(:requirements 
	:typing :durative-actions :numeric-fluents
)
(:types 
	location locatable - objects
	)

(:predicates
	(at ?o - locatable ?l - location)
)
	
;;доехать до места чс
(:durative-action move-amb
	:parameters 
		(?o - locatable ?l - location)
    :duration 
		(= ?duration 1)
    :condition 
		(and (at start (at ?o ?l)))
    :effect 
		(at end not(at ?o ?l))
)


)

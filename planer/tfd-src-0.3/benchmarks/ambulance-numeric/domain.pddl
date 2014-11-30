(define 
	(domain ambulance)
	
(:requirements :typing :durative-actions :numeric-fluents)

(:types 
	location locatable - objects
	ward reanimation - objects
	traumatology neurosurgery surgery-ic surgery-no-ic thermal-chemical - ward
	injured ambulance - locatable
	brk-bone brain h-internal l-internal burn - injured
	hospital accident - location
)

(:predicates
	(road ?l1 ?l2 - location)
	;;дорога
	(at ?x - locatable ?y - location)
	;;х находится в у
	
	;;(amb-at-hsp ?x - ambulance y? - hospital)
	;;скорая х находится в больнице у
	(rnm-at-hsp ?x - reanimation ?y - hospital)
	;;реанимация х находится в больнице у
	(wrd-at-hsp ?x - ward ?y - hospital)
	;;отделение х находится в больнице у
	
	(inj-in-amb ?x - injured ?y - ambulance)
	;;пострадавший х находится в машине скорой у
	(inj-in-rnm ?x - injured ?y - reanimation)
	;;пострадавший х находится в реанимации у
	(inj-in-wrd ?x - injured ?y - ward)
	;;пострадавший х находится в отделении у
	
	(hsp-has-wrd ?h - hospital ?w - ward)
	;;отделение в больнице
	
	(inj-and-wrd ?i - injured ?w - ward)
	;;травма соответствует отделению
	
	(amb-rdy ?x - ambulance)
	;;скорая готова к перевозке
	
	(rnm-rdy ?x - reanimation)
	;;реанимация готова к приему пациента
)
	
(:functions
	(ward-capacity ?w - ward) - number
	;;кол-во мест в отделении
	
    (road-length ?l1 ?l2 - location) - number
	;;длина пути (время в пути от l1 до l2)
	
	(time-to-operate ?x - injured) - number
	;;время на операцию для травмы х
	
	(time-to-hosp ?x - injured) - number
	;;время на госпитализацию для травмы х
)

;;доехать до места чс
(:durative-action move-amb
	:parameters 
		(?a - ambulance ?l - accident ?al - location)
    :duration 
		(= ?duration (road-length ?al ?l))
    :condition 
		(and
		(at start (at ?a ?al))
		(at start (road ?al ?l))
		(at start (not(at ?a ?l)))
		(at start (amb-rdy ?a))
		)
    :effect 
		(and
		(at start (not(at ?a ?al)))
		(at start (not(amb-rdy ?a)))
        (at end (at ?a ?l))
        (at end (amb-rdy ?a))
		)
)

;;забрать пострадавшего с места чс
(:durative-action amb-load-inj
	:parameters 
		(?a - ambulance ?l - location ?i - injured)
    :duration 
		(= ?duration 1)
    :condition 
		(and
		(at start (at ?a ?l))
		(over all (at ?a ?l))
		(at start (amb-rdy ?a))
		)
    :effect 
		(and
        (at end (inj-in-amb ?i ?a))
        (at start (not (amb-rdy ?a)))
        (at end (amb-rdy ?a))
		)
)

;;госпитализировать пострадавшего по прибытию в больницу
(:durative-action amb-unload-inj
	:parameters 
		(?a - ambulance ?l - location ?i - injured ?r - reanimation)
    :duration 
		(= ?duration (time-to-hosp ?i))
    :condition 
		(and
		(at start (at ?a ?l))
		(at start (inj-in-amb ?i ?a))
		(at start (amb-rdy ?a))
		(at start (rnm-rdy ?r))
		)
    :effect 
		(and
		(at start (not (amb-rdy ?a)))
		(at end (amb-rdy ?a))
        (at start (not (inj-in-amb ?i ?a)))
		(at start (not (inj-in-rnm ?i ?r)))
		(at end (inj-in-rnm ?i ?r))
		(at end (not (rnm-rdy ?r)))
		)
)

;; провести операцию
(:durative-action rnm-oper-inj
	:parameters 
		(?i - injured ?r - reanimation ?w - ward)
    :duration 
		(= ?duration (time-to-operate ?i))
    :condition 
		(and
		(at start (inj-in-rnm ?i ?r))
		(at start (not (rnm-rdy ?r)))
		)
    :effect 
		(and
		(at end (not (inj-in-rnm ?i ?r)))
		(at end (rnm-rdy ?r))
		(at end ((inj-in-wrd ?i - injured ?w - ward)))
		(at end (decrease (ward-capacity ?w) 1))
		)
)

;;перевезти пострадавшего в соответствующее травме мед учреждение
(:durative-action move-to-hsp
	:parameters 
		(?i - injured ?a - ambulance ?l - accident ?h - hospital ?w - ward ?r - reanimation)
    :duration 
		(= ?duration (road-length ?l ?h))
    :condition 
		(and
		(at start (at ?a ?l))
		(at start (road ?l ?h))
		(at start (inj-in-amb ?i ?a))
		(at start (inj-and-wrd ?i ?w))
		(at start (wrd-at-hsp ?w ?h))
		)
    :effect 
		(and
		(at start (not (at ?a ?l)))
		(at end (at ?a ?h))
		)
)

)

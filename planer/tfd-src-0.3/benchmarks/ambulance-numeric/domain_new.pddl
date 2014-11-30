(define (domain ambulance)
	
(:requirements :typing :durative-actions :numeric-fluents)

(:types
	location locatable - objects
	injured ambulance ward reanimation - locatable
	
	;;hospital accident - location
	;;traumatology neurosurgery surgery-ic surgery-no-ic thermal-chemical - ward
	;;brk-bone brain h-internal l-internal burn - injured
)

(:predicates
	;;дорога
	(road ?l1 ?l2 - location)
	
	;;х расположен в у
	(at ?x - locatable ?y - location)
	
	;;х находится в у
	(in ?x - locatable ?y - locatable)
	
	;;скорая готова к перевозке
	(amb-rdy ?x - ambulance)
	
	;;реанимация готова к приему пациента
	(rnm-rdy ?x - reanimation)
	
	;;травма соответствует отделению
	;;(inj-and-wrd ?i - injured ?w - ward)
)
	
(:functions
	;;кол-во мест в отделении
	;;(ward-capacity ?w - ward)
	
	;;длина пути (время в пути от l1 до l2)
    (road-length ?l1 ?l2 - location)
	
	;;время на операцию для травмы х
	(time-to-operate ?x - injured)
	
	;;время на госпитализацию для травмы х
	;;(time-to-hosp ?x - injured)
)

;;движение скорой
(:durative-action drive
	:parameters
		(?a - ambulance ?l1 ?l2 - location)
	:duration
		(= ?duration (road-length ?l1 ?l2))
	:condition (and
        (at start (at ?a ?l1))
        (at start (road ?l1 ?l2))
      )
    :effect (and
        (at start (not (at ?a ?l1)))
        (at end (at ?a ?l2))
      )
)

;;забрать пострадавшего
(:durative-action amb-load-inj
	:parameters 
		(?a - ambulance ?l - location ?i - injured)
    :duration 
		(= ?duration 1)
    :condition (and
        (at start (at ?a ?l))
        ;;(over all (at ?a ?l))
        (at start (at ?i ?l))
        (at start (amb-rdy ?a))
      )
    :effect (and
        (at start (not (at ?i ?l)))
        (at end (in ?i ?a))
        (at start (not (amb-rdy ?a)))
        (at end (amb-rdy ?a))
      )
)

;;госпитализировать пострадавшего по прибытию в больницу
(:durative-action amb-unload-inj
	:parameters 
		(?a - ambulance ?l - location ?i - injured ?r - reanimation ?w - ward)
    :duration 
		(= ?duration (time-to-operate ?i))
	:condition (and
		(at start (at ?r ?l))
		(at start (at ?w ?l))
		(at start (at ?a ?l))
        ;;(over all (at ?a ?l))
        (at start (in ?i ?a))
        (at start (amb-rdy ?a))
		(at start (rnm-rdy ?r))
      )
    :effect (and
        (at start (not (in ?i ?a)))
		(at start (not (rnm-rdy ?r)))
		(at start (not (amb-rdy ?a)))
		(at start (in ?i ?r))
        (at end (at ?i ?l))
        (at end (amb-rdy ?a))
		(at end (not (in ?i ?r)))
		(at end (rnm-rdy ?r))
		(at end (in ?i ?w))
      )
)
)

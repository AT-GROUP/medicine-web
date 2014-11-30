(define (problem ambulance-3h-4a)
	(:domain ambulance)
	(:objects
		hospital-1 - hospital
		
		accident-1 - accident
		
		reanimation-11 - reanimation
		
		ambulance-1 - ambulance
		ambulance-2 - ambulance
		
		traumatology-1 - traumatology
		thermal-chemical-1 - thermal-chemical
		
		
		brk-bone-1 - brk-bone 
		burn-1 - burn
	)
	(:init
		(road-h1-acc1 hospital-1 accident-1)
		(= (road-length hospital-1 accident-1) 20)
		(road-acc1-h1 accident-1 hospital-1)
		(= (road-length accident-1 hospital-1) 20)
		;;
		(at ambulance-1 hospital-1)
		(at ambulance-2 hospital-1)
		;;
		(amb-rdy ambulance-1)
		(amb-rdy ambulance-2)
		;;
		(rnm-rdy reanimation-11)
		(rnm-rdy reanimation-12)
		;;
		(rnm-at-hsp reanimation-11 hospital-1)
		(rnm-at-hsp reanimation-12 hospital-1)
		;;
		(wrd-at-hsp traumatology-1 hospital-1)
		(wrd-at-hsp thermal-chemical-1 hospital-1)
		;;
		(inj-and-wrd brk-bone-1 traumatology-1)
		(inj-and-wrd burn-1 thermal-chemical-1)
		;;
		(= (time-to-operate brk-bone-1) 2)
		(= (time-to-operate burn-1) 7)
		;;
		(= (time-to-hosp brk-bone-1) 1)
		(= (time-to-hosp burn-1) 3)
		;;
		(= (ward-capacity traumatology-1) 5)
		(= (ward-capacity thermal-chemical-1) 5)
		;;
	)
	
	(:goal (and
	(inj-in-wrd brk-bone-1 traumatology-1)
	(inj-in-wrd burn-1 thermal-chemical-1))
	)
	(:metric minimize (total-time))
)
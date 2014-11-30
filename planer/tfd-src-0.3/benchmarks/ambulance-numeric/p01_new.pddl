(define (problem ambulance-3h-4a)
	(:domain ambulance)
	(:objects
		hospital-1 - location
		hospital-2 - location
		hospital-3 - location
		
		accident-1 - location
		
		reanimation-11 - reanimation
		reanimation-21 - reanimation
		reanimation-22 - reanimation
		reanimation-31 - reanimation
		
		ambulance-1 - ambulance
		ambulance-2 - ambulance
		ambulance-3 - ambulance
		ambulance-4 - ambulance
		
		traumatology-1 - ward
		neurosurgery-1 - ward
		surgery-ic-1 - ward
		surgery-no-ic-1 - ward
		thermal-chemical-1 - ward
		
		
		brk-bone-1 - injured 
		brain-1 - injured
		h-internal-1 - injured
		l-internal-1 - injured
		burn-1 - injured
	)
	(:init
		(road hospital-1 accident-1)
		(= (road-length hospital-1 accident-1) 20)
		(road accident-1 hospital-1)
		(= (road-length accident-1 hospital-1) 20)
		;;
		(road hospital-2 accident-1)
		(= (road-length hospital-2 accident-1) 25)
		(road accident-1 hospital-2)
		(= (road-length accident-1 hospital-2) 25)
		;;
		(road hospital-3 accident-1)
		(= (road-length hospital-3 accident-1) 22)
		(road accident-1 hospital-3)
		(= (road-length accident-1 hospital-3) 22)
		;;
		(at ambulance-1 hospital-1)
		(at ambulance-2 hospital-1)
		(at ambulance-3 hospital-2)
		(at ambulance-4 hospital-3)
		;;
		(at brk-bone-1 accident-1)
		(at brain-1 accident-1)
		(at h-internal-1 accident-1)
		(at l-internal-1 accident-1)
		(at burn-1 accident-1)
		;;
		(amb-rdy ambulance-1)
		(amb-rdy ambulance-2)
		(amb-rdy ambulance-3)
		(amb-rdy ambulance-4)
		;;
		(rnm-rdy reanimation-11)
		(rnm-rdy reanimation-21)
		(rnm-rdy reanimation-22)
		(rnm-rdy reanimation-31)
		;;
		(at reanimation-11 hospital-1)
		(at reanimation-21 hospital-2)
		(at reanimation-22 hospital-2)
		(at reanimation-31 hospital-3)
		;;
		(at traumatology-1 hospital-1)
		(at neurosurgery-1 hospital-1)
		(at surgery-ic-1 hospital-2)
		(at surgery-no-ic-1 hospital-3)
		(at thermal-chemical-1 hospital-3)
		;;
		(= (time-to-operate brk-bone-1) 2)
		(= (time-to-operate brain-1) 10)
		(= (time-to-operate h-internal-1) 10)
		(= (time-to-operate l-internal-1) 5)
		(= (time-to-operate burn-1) 7)
		;;
		;;(= (time-to-hosp brk-bone-1) 1)
		;;(= (time-to-hosp brain-1) 3)
		;;(= (time-to-hosp h-internal-1) 8)
		;;(= (time-to-hosp l-internal-1) 3)
		;;(= (time-to-hosp burn-1) 3)
		;;
		;;(= (ward-capacity traumatology-1) 5)
		;;(= (ward-capacity neurosurgery-1) 5)
		;;(= (ward-capacity surgery-ic-1) 5)
		;;(= (ward-capacity surgery-no-ic-1) 5)
		;;(= (ward-capacity thermal-chemical-1) 5)
		;;
	)
	
	(:goal (and
	(in brk-bone-1 traumatology-1)
	(in brain-1 neurosurgery-1)
	(in h-internal-1 surgery-ic-1)
	(in l-internal-1 surgery-no-ic-1)
	(in burn-1 thermal-chemical-1))
	)
	(:metric minimize (total-time))
)

(define (problem ambulance-3h-4a)
	(:domain ambulance)
	(:objects
		hospital-1 - hospital
		hospital-2 - hospital
		hospital-3 - hospital
		
		somewhere-1 - location
		somewhere-2 - location
		
		accident-1 - accident
		
		reanimation-11 - reanimation
		reanimation-12 - reanimation
		reanimation-21 - reanimation
		reanimation-22 - reanimation
		reanimation-23 - reanimation
		reanimation-31 - reanimation
		reanimation-32 - reanimation
		
		ambulance-1 - ambulance
		ambulance-2 - ambulance
		ambulance-3 - ambulance
		ambulance-4 - ambulance
		ambulance-5 - ambulance
		ambulance-6 - ambulance
		
		traumatology-1 - traumatology
		neurosurgery-1 - neurosurgery
		surgery-ic-1 - surgery-ic
		surgery-no-ic-1 - surgery-no-ic
		thermal-chemical-1 - thermal-chemical
		
		
		brk-bone-1 - brk-bone 
		brain-1 - brain
		h-internal-1 - h-internal
		l-internal-1 - l-internal
		burn-1 - burn
	)
	(:init
		(road-h1-acc1 hospital-1 accident-1)
		(= (road-length hospital-1 accident-1) 20)
		(road-acc1-h1 accident-1 hospital-1)
		(= (road-length accident-1 hospital-1) 20)
		;;
		(road-h2-acc1 hospital-2 accident-1)
		(= (road-length hospital-2 accident-1) 25)
		(road-acc1-h2 accident-1 hospital-2)
		(= (road-length accident-1 hospital-2) 25)
		;;
		(road-h3-acc1 hospital-3 accident-1)
		(= (road-length hospital-3 accident-1) 22)
		(road-acc1-h3 accident-1 hospital-3)
		(= (road-length accident-1 hospital-3) 22)
		;;
		(road-sw1-acc1 somewhere-1 accident-1)
		(= (road-length somewhere-1 accident-1) 15)
		(road-acc1-sw1 accident-1 somewhere-1)
		(= (road-length accident-1 somewhere-1) 15)
		;;
		(road-sw2-acc1 somewhere-2 accident-1)
		(= (road-length somewhere-2 accident-1) 30)
		(road-acc1-sw1 accident-1 somewhere-2)
		(= (road-length accident-1 somewhere-2) 10)
		;;
		(at ambulance-1 hospital-1)
		(at ambulance-2 hospital-1)
		(at ambulance-3 hospital-2)
		(at ambulance-4 hospital-3)
		(at ambulance-5 somewhere-1)
		(at ambulance-6 somewhere-2)
		;;
		(amb-rdy ambulance-1)
		(amb-rdy ambulance-2)
		(amb-rdy ambulance-3)
		(amb-rdy ambulance-4)
		(amb-rdy ambulance-5)
		(amb-rdy ambulance-6)
		;;
		(rnm-rdy reanimation-11)
		(rnm-rdy reanimation-12)
		(rnm-rdy reanimation-21)
		(rnm-rdy reanimation-22)
		(rnm-rdy reanimation-23)
		(rnm-rdy reanimation-31)
		(rnm-rdy reanimation-32)
		;;
		(rnm-at-hsp reanimation-11 hospital-1)
		(rnm-at-hsp reanimation-12 hospital-1)
		(rnm-at-hsp reanimation-21 hospital-2)
		(rnm-at-hsp reanimation-22 hospital-2)
		(rnm-at-hsp reanimation-23 hospital-2)
		(rnm-at-hsp reanimation-31 hospital-3)
		(rnm-at-hsp reanimation-32 hospital-3)
		;;
		(wrd-at-hsp traumatology-1 hospital-1)
		(wrd-at-hsp neurosurgery-1 hospital-1)
		(wrd-at-hsp surgery-ic-1 hospital-2)
		(wrd-at-hsp surgery-no-ic-1 hospital-3)
		(wrd-at-hsp thermal-chemical-1 hospital-3)
		;;
		(inj-and-wrd brk-bone-1 traumatology-1)
		(inj-and-wrd brain-1 neurosurgery-1)
		(inj-and-wrd h-internal-1 surgery-ic-1)
		(inj-and-wrd l-internal-1 surgery-no-ic-1)
		(inj-and-wrd burn-1 thermal-chemical-1)
		;;
		(= (time-to-operate brk-bone-1) 2)
		(= (time-to-operate brain-1) 10)
		(= (time-to-operate h-internal-1) 10)
		(= (time-to-operate l-internal-1) 5)
		(= (time-to-operate burn-1) 7)
		;;
		(= (time-to-hosp brk-bone-1) 1)
		(= (time-to-hosp brain-1) 3)
		(= (time-to-hosp h-internal-1) 8)
		(= (time-to-hosp l-internal-1) 3)
		(= (time-to-hosp burn-1) 3)
		;;
		(= (ward-capacity traumatology-1) 5)
		(= (ward-capacity neurosurgery-1) 5)
		(= (ward-capacity surgery-ic-1) 5)
		(= (ward-capacity surgery-no-ic-1) 5)
		(= (ward-capacity thermal-chemical-1) 5)
		;;
	)
	
	(:goal (and
	(inj-in-wrd brk-bone-1 traumatology-1)
	(inj-in-wrd brain-1 neurosurgery-1)
	(inj-in-wrd h-internal-1 surgery-ic-1)
	(inj-in-wrd l-internal-1 surgery-no-ic-1)
	(inj-in-wrd burn-1 thermal-chemical-1))
	)
	(:metric minimize (total-time))
)
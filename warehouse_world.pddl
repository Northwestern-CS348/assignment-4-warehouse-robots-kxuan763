(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action pickupPallette
     :parameters (?r - robot ?l - location ?p -pallette)
     :precondition (and
            (free ?r)
            (at ?r ?l)
            (at ?p ?l)
     )
     :effect (and
            (not (free ?r))
            (has ?r ?p)
     )
   )
   
   (:action putdownPallette
      :parameters (?r - robot ?l - location ?p - pallette)
      :precondition (and
            (has ?r ?p)
            (not (free ?r))
            (at ?r ?l)
            (at ?p ?l)  
      )
      :effect (and
            (free ?r)
            (not (has ?r ?p))
      )
   )

    (:action robotMoveWithoutPallette
      :parameters (?r - robot ?loc1 - location ?loc2 - location)
      :precondition (and
            (free ?r)
            (at ?r ?loc1)
            (no-robot ?loc2)
            (connected ?loc1 ?loc2)
      )
      :effect (and
            (not (at ?r ?loc1))
            (not (no-robot ?loc2))
            (at ?r ?loc2)
            (no-robot ?loc1)
      )
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?loc1 - location ?loc2 - location ?p - pallette)
      :precondition (and
            (has ?r ?p)
            (not (free ?r))
            (at ?r ?loc1)
            (at ?p ?loc1)
            (no-robot ?loc2)
            (no-pallette ?loc2)
            (connected ?loc1 ?loc2)
      )
      :effect (and
            (not (at ?r ?loc1))
            (not (at ?p ?loc1))
            (at ?r ?loc2)
            (at ?p ?loc2)
            (not (no-robot ?loc2))
            (not (no-pallette ?loc2))
            (no-robot ?loc1)
            (no-pallette ?loc1)
      )
   )
   
   
   (:action moveItemFromPalletteToShipment
      :parameters (?p - pallette ?s - shipment ?o - order ?si - saleitem ?l - location)
      :precondition (and
            (ships ?s ?o)
            (orders ?o ?si)
            (contains ?p ?si)
            (packing-at ?s ?l)
            (started ?s)
            (at ?p ?l)
      )
      :effect (and
            (not (contains ?p ?si))
    	    (includes ?s ?si)
      )
   )
   
   (:action completeShipment
      :parameters (?s -shipment ?o - order ?si -saleitem ?l - location)
      :precondition (and
            (ships ?s ?o)
            (orders ?o ?si)
            (includes ?s ?si)
      )
      :effect (and
            (not (started ?s))
            (complete ?s)
            (available ?l)
            (not (packing-at ?s ?l))
            (not (ships ?s ?o))
    	    (not (orders ?o ?si))
      )
   )
)
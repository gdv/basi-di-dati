-- Determinare per quali viaggi sia stato utilizzato un biglietto per una durata compessiva del viaggio superiore a quella del biglietto.

select *
from biglietto join viaggio on viaggio.biglietto=biglietto.id
where biglietto.durata < viaggio.arrivo-viaggio.partenza

-- Individuare la stazione da cui sono partiti più viaggi nel 2010.

create view viaggi_2010(stazione, numero) as
       select partenza, count(*)
       from viaggio
       where year(partenza)=2010
       group by partenza

select *
from viaggi_2010
where numero >= all (select max(numero)
      	     	     from viaggi_2010
		     )

-- Determinare le persone che sono state titolare di almeno due abbonamenti.

select *
from abbonamento a1, abbonamento a2
where a1.titolare=a2.titolare and a1.id<>a2.id

-- Determinare le stazioni che sono state partenza di almeno un viaggio, senza mai essere stazioni di arrivo di un viaggio.

select partenza
from viaggio
where partenza not in
      (select arrivo
       from viaggio)

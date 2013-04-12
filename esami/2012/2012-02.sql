-- Elencare gli oggetti i cui vertici sono stati inseriti dallo stesso utente.

create view oggetti_diversi_utenti(oggetto_utente, oggetto_inserimento) as
       select o1.respo, o1.inserimento
       from oggetto, rilevazione r1, rilevazione r2
       where r1.inserimento=o1.inserimento and r1.respo=o1.respo and
       	     r2.inserimento=o2.inserimento and r2.respo=o2.respo and
	     o1.respo=o2.respo and r1.respr<>r2.respr

select inserimento, respo
from oggetto
except
select oggetto_utente, oggetto_inserimento
from oggetti_diversi_utenti

-- Determinare quale oggetto è associato al numero massimo di vertici.

create view quanti_vertici(oggetto_utente, oggetto_inserimento, numero_vertici) as
       select inserimento, respo, count(*)
       from vertice
       group by inserimento, respo

select *
from quanti_vertici
where numero_vertici >= all (select numero_vertici
      		     	     from quanti_vertici)

-- Esprimere il vincolo che ogni collegamento valido sia associato a due rilevazioni valide.
check(0 >= select *
	   from collegamento join  rilevazione on collegamento.punto1_latitudine=rilevazione.latitudine and
     	   	      	  		          collegamento.punto1_longitudine=rilevazione.longitudine and
				       		  collegamento.punto1_dataora=rilevazione.dataora
           where collegamento=valido and not rilevazione.valido)
check(0 >= select *
	   from collegamento join  rilevazione on collegamento.punto2_latitudine=rilevazione.latitudine and
     	   	      	  		          collegamento.punto2_longitudine=rilevazione.longitudine and
				       		  collegamento.punto2_dataora=rilevazione.dataora
           where collegamento=valido and not rilevazione.valido)

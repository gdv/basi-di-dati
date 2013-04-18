-- Determinare il seggio dove si sono verificati il numero massimo di voti validi.

create view voti_per_seggio (seggio, voto) as
       select seggio, count(*)
       from voto
       group by seggio

select *
from voti_per_seggio
where voti >= all (select max(voti)
      	      	   from voti_per_seggio)


-- Scrivere la condizione che verifica che il vincolo “non è possibile dare una preferenza senza indicare una lista” sia soddisfatto.

create table voto (
 id integer primary key,
 ....
 preferenza char(16) references candidato(codicefiscale) null
)


-- Determinare i candidati che non hanno ricevuto preferenze.

select codicefiscale
from candidato
where not exists (select *
      	  	  from voto
		  where preferenza.codicefiscale=candidato.codicefiscale)

-- Determinare quale classe di analisi è stata eseguita il numero massimo di volte nel mese di Giugno 2011.

create view analisi_ripartite_per_classe (classe, numero) as
       select tipo, count(*)
       from analisi
       group by tipo

select *
from analisi_ripartite_per_classe
where numero >= all (select max(numero)
      	     	     from analisi_ripartite_per_classe)

-- Determinare per ogni laboratorio il tempo medio di esecuzione di una richiesta di analisi.

create view analisi_tempo (analisi, laboratorio, tempo) as
       select analisi.id, laboratorio.codice, analisi.dcompletamento-esecuzione_data
       from analisi join laboratorio on analisi.esecuzione=laboratorio.codice


select laboratorio, avg(tempo)
from analisi_temp
group by laboratorio

-- Elencare i laboratori che, nel mese di Giugno 2011, hanno eseguito tutti le analisi relativi alle richieste che hanno gestito.

select laboratorio.codice
from laboratorio l1
where not exists (
      select *
      from analisi, richanalisi, laboratorio l2
      where analisi.esecuzione=l1.codice and analisi.setanalisi=richanalisi.progr and
       	     richanalisi.competenza=l2.codice and l1.codice<>l2.codice and
	     month(esecuzione_data)=6 and year(esecuzione_data)=2011 )



-- Scrivere l'istruzione che impone che una richiesta di analisi non possa contenere due analisi della stessa classe.

check(0>=
	select count(*)
	from analisi a1 join analisi a2 on a1.richanalisi=a2.richanalisi and a1.tipo=a2.tipo
	where a1.id <> a2.id
	)

-- Determinare quale pilota è stato vice pilota il numero massimo di volte sulla tratta LIN-MAD (bisogna sommare il numero di volte che è stato vice pilota all'andata con quello per il ritorno)

create view vice_linmad(vice, numero) as
       select volo.vicepilota, count(*)
       from volo
       where volo.da='MAD' and volo.a='LIN' or volo.a='MAD' and volo.da='LIN'
       group by volo.vicepilota

select *
from vice_linmad
where numero >= (select max(numero)
      	     	 from vice_linmad)


-- Determinare tutte le volte un pilota ha fatto sia l'andata che il ritorno di una stessa tratta in un unico giorno con lo stesso aereo. Per esempio un certo pilota ha pilotato l'aereo con codice 2324 sia nella tratta LIN-MAD che MAD-LIN, entrambe in data 01/01/2011. Si può assumere che nessun pilota possa pilotare più di 2 voli in uno stesso giorno.

select *
from volo v1, volo v2
where v1.da=v2.a and v2.da=v1.a and v1.pilota=v2.pilota and
      year(v1.partenza)=year(v2.partenza) and month(v1.partenza)=month(v2.partenza) and
      day(v1.partenza)=day(v2.partenza)


-- Scrivere l'istruzione che impone che il pilota di ogni volo sia effettivamente autorizzato.

check(0>=
select count(*)
from dipendente
where CF not in (
      	     	select dipendente.CF
		from volo, aereo, modello, dipendente
		where volo.macchina=aereo.codice and aereo.parco=modello.nome and
		      autorizzazione.modello=modello.nome and autorizzazione.dipendente=dipendente.CF and
		            and volo.pilota=dipendente.CF)
)

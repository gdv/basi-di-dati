-- Determinare le persone che amministrano il numero massimo di corsi.

create view amministratori_corsi (amministratore, numero) as
       select amministratore, count(*)
       from corso
       group by amministratore

select *
from amministratori_corsi
where numero >= (select max(numero)
      	     	 from amministratori_corsi)

-- Determinare gli studenti che hanno sostenuto almeno due prove di uno stesso corso.

create view studente_corso_prove (studente, corso, progressivo) as
       select svolgimento.studente, prove_corso, prove_progressivo
       from svolgimento, domande
       where svolgimento.domande_progressivo=domande.progressivo and
     	     svolgimento.domande_prove_progressivo=domande.prove_progressivo and
     	     svolgimento.domande_prove_corso=domande.prove_corso and
       group by svolgimento.studente, prove_corso, prove_progressivo

select *
from studente_corso_prove s1 join studente_corso_prove s2 on s1.studente=s2.studente
where s1.corso=s2.corso and s1.progresivo<=s2.progressivo
-- oppure

create view studente_corso_prove (studente, corso) as
       select svolgimento.studente, prove_corso, prove_progressivo
       from svolgimento
       group by studente, prove_corso, prove_progressivo

select *
from studente_corso_prove s1 join studente_corso_prove s2 on s1.studente=s2.studente
where s1.corso=s2.corso and s1.progresivo<=s2.progressivo
-- Determinare gli studenti che hanno sostenuto tutte le prove di uno stesso corso.

select distinct studente
from  studente_corso_prove
where not exists (select *
      	  	  from prove
		  where studente_corso_prove.corso=prove.corso and not exists (select *
		  							       from studente_corso_prove sc2
								 	       where sc2.corso=prove.corso and
									       	     sc2.studente=sc1.studente and
										     prove.progressivo=sc2.progressivo))


-- Determinare le persone che sono docenti solo di corsi che amministrano (potrebbero amministrare corsi di cui non sono docenti).

select u1.username
from utenti_in_corso u1
where u1.is_docente and
      not exists (select *
      	  	  from corso, utenti_in_corso u2
		  where u1.username=u2.username and
		  	u2.is_docente and
		    	u2.iscrizione=corso.codice and
		  	corso.amministratore<>u1.username)

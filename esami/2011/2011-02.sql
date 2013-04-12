-- Determinare la composizione delle proprietà della società con simbolo FIAT (per ogni proprietario elencare il numero di azioni possedute, sia in valore assoluto che in percentuale) alla data odierna.

create view totale_acquisti_fiat(persona, societa, numero_acquistate) as
       select persona.cf, azionisocieta.id, sum(compravendita.num_azioni)
       from azionisocieta, compravendita, parte, persona
       where azionisocieta.id=compravendita.societa and compravendita.acquisto=parte.id
       	     and parte.id=persona.parte and azionisocieta.id='FIAT'

create view totale_vendite_fiat(persona, societa, numero_vendute) as
       select persona.cf, azionisocieta.id, sum(compravendita.num_azioni)
       from azionisocieta, compravendita, parte, persona
       where azionisocieta.id=compravendita.societa and compravendita.vendita=parte.id
       	     and parte.id=persona.parte and azionisocieta.id='FIAT'

create view situazione_fiat(persona, societa, saldo) as
       select persona, azionisocieta.id, numero_acquistate-numero_vendute as saldo
       from totale_vendite_fiat join totale_acquisti_fiat on totale_vendite_fiat.persona=totale_acquisti_fiat.persona
       where numero_acquistate>numero_vendute

select persona, azioni, azioni/qtot as percentuale
from situazione_fiat join azionisocieta on situazione_fiat.societa=azionisocieta.id

-- Individuare l'acquirente che ha comprato il numero massimo di azioni FIAT nel mese di Dicembre 2010.

create view acquisti_fiat_dic2010(parte, totale) as
       select persona.cf, sum(compravendita.num_azioni)
       from azionisocieta, compravendita, parte
       where azionisocieta.id=compravendita.societa and compravendita.acquisto=parte.id and
       	     azionisocieta.id='FIAT' and year(data)=2010 and month(data)=12

select *
from acquisti_fiat_dic2010
where totale >= all (select max(totale)
      	     	     from acquisti_fiat_dic2010)

-- Determinare i casi in cui un'azienda che agisce anche come intermediario che ha acquistato in proprio azioni di una società per cui ha agito da intermediario in una vendita, e le due operazioni sono avvenute nello stesso giorno.

create view intermediate(intermediario, societa, data) as
       select intermediario.partitaIVA, compravendita.data, azionisocieta.id
       from intermediazioni, compravendita, azionisocieta
       where azionisocieta.id=compravendita.societa and compravendita.intermediazione=intermediario.partitaIVA
       group by intermediario.partitaIVA, compravendita.data, azionisocieta.id

create view acquisti_intermediario(intermediario, societa, data) as
       select azienda.partitaIVA, compravendita.data, azionisocieta.id
       from acquisto, compravendita, azionisocieta
       where azionisocieta.id=compravendita.societa and compravendita.acquisto=parte.id and
       	     and parte.id=azienda.parte and azienda.is_intermediario
       group by intermediario.partitaIVA, compravendita.data, azionisocieta.id

select acquisti_intermediario.intermediario, acquisti_intermediario.societa, acquisti_intermediario.data
       from acquisti_intermediario join intermediate on
       	    intermediate.intermediario=acquisti_intermediario.intermediario and
	    intermediate.societa=acquisti_intermediario.societa and
	    intermediate.data=acquisti_intermediario.data

-- Determinare le operazioni di compravendita che violano il quantitativo minimo.
select *
from compravendita join azionisocieta on azionisocieta.id=compravendita.societa
where num_azioni < qmin

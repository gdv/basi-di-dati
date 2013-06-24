 -- Quale è l’utente che è proprietario del numero maggiore di file?.

create view file_utente (username, quanti, spazio_totale, spazio) as
    select utente.nome, count(*) as quanti, sum(dimensione) as spazio_totale, spazio
    from utente join file on file.proprieta=utente.username
    group by username

select *
from file_utente
where quanti >= select max(quanti)
                from file_utente

 -- Determinare gli utenti che appartengono solo a gruppi di cui sono proprietari.

select *
from utente
where not exists    select *
                    from gruppo join appartiene on gruppo.nome=appartiene.grupponome and gruppo.proprietario=appartiene.username
                    where utente.username<>gruppo.proprietario

 -- Determinare i file di cui esistono due versioni fatte da utenti diversi.

select file.nome, file.cartella
from versione v1, versione v2, file
where v1.filenome=file.nome and v1.cartella=file.cartella and 
      v2.filenome=file.nome and v2.cartella=file.cartella and
      v1,utente <> v2.utente and
      v1.id<>v2.id

 -- Scrivere la check che impone il fatto che ogni utente usi uno spazio complessivo (inteso come somma delle dimensioni dei file di cui è proprietario) non superiore a quello permesso.

check (0 =  select count(*)
            from file_utente join utente on utente.username=file
            where spazio_totale > spazio)

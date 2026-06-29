USE smart_farming;

#Bestiame in stato di salute critico ordinato per numero di capi

SELECT specie, razza, numero_capi, stato_salute
FROM bestiame
WHERE stato_salute = 'Critico'
ORDER BY numero_capi DESC;


#Prodotti preferiti divisi per genere del cliente

SELECT c.genere, p.nome AS prodotto, COUNT(*) AS numero_acquisti
FROM vendita v
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN prodotto p ON v.id_prodotto = p.id_prodotto
GROUP BY c.genere, p.nome
ORDER BY c.genere, numero_acquisti DESC;


#fatturato per produttore

SELECT pr.nome_azienda, SUM(v.prezzo_totale) AS fatturato
FROM vendita v
JOIN produttore pr ON v.id_produttore = pr.id_produttore
GROUP BY pr.nome_azienda
ORDER BY fatturato DESC;



#differenze utilizzo singola risorsa dalle aziende (aziende più virtuose)

SELECT pr.nome_azienda, u.tipo_risorsa, SUM(u.quantita_usata) AS totale_usato, i.unita_misura
FROM produttore pr
JOIN attivita a ON pr.id_produttore = a.id_produttore
JOIN uso_risorsa u ON a.id_attivita = u.id_attivita
JOIN inventario_risorsa i ON pr.id_produttore = i.id_produttore
   AND u.tipo_risorsa = i.tipo_risorsa
GROUP BY pr.nome_azienda, u.tipo_risorsa, i.unita_misura
having tipo_risorsa = 'Gasolio agricolo';



# Scorte dei produttori ordinate per data di aggiornamento

SELECT s.id_produttore, p.nome AS Prodotto, s.quantita_disponibile, s.unita_misura, s.data_aggiornamento
FROM scorta s
JOIN prodotto p ON s.id_prodotto = p.id_prodotto
ORDER BY data_aggiornamento DESC;


#produttori con piu quantità disponibile per ogni tipo di risorsa

SELECT i.tipo_risorsa, p.nome_azienda, p.nome, p.cognome, i.quantita_disponibile, i.unita_misura
FROM inventario_risorsa i
JOIN produttore p ON i.id_Produttore = p.id_produttore
ORDER BY i.tipo_risorsa, i.quantita_disponibile DESC;
    



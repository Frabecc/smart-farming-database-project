# Analisi delle Vendite Mensili per Prodotto
SELECT YEAR(v.data_ora) AS Anno, MONTH(v.data_ora) AS Mese, p.nome AS Prodotto, SUM(v.prezzo_totale) AS Fatturato_Totale,
	COUNT(v.id_vendita) AS Numero_Transazioni
FROM vendita v
JOIN prodotto p ON v.id_prodotto = p.id_prodotto
GROUP BY YEAR(v.data_ora), MONTH(v.data_ora), p.nome
ORDER BY Anno DESC, Mese DESC, Fatturato_Totale DESC;

# I 5 Clienti che hanno effettuato almeno un acquisto ma che hanno speso meno
SELECT c.nome, c.cognome, SUM(v.prezzo_totale) AS Totale_Speso, c.indirizzo_email, c.numero_telefono
FROM cliente c
JOIN vendita v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome, c.cognome
ORDER BY Totale_Speso ASC
LIMIT 5;

# Calcola quante vendite ha fatto ogni genere, quanto hanno speso in totale e l'età media degli acquirenti per quel genere
SELECT c.genere AS Genere_Cliente, COUNT(v.id_vendita) AS Totale_Acquisti, SUM(v.prezzo_totale) AS Fatturato_Generato,
	ROUND(AVG(TIMESTAMPDIFF(YEAR, c.data_nascita, CURDATE())), 0) AS Eta_Media
FROM cliente c
JOIN vendita v ON c.id_cliente = v.id_cliente
WHERE c.genere IS NOT NULL AND c.data_nascita IS NOT NULL
GROUP BY c.genere
ORDER BY Fatturato_Generato DESC;

# Raggruppiamo i clienti per il loro anno di nascita per capire quali "annate" spendono di più nella nostra fattoria (mostra le prime 10)
SELECT YEAR(c.data_nascita) AS Anno_Di_Nascita, COUNT(v.id_cliente) AS Numero_Ordini, SUM(v.prezzo_totale) AS Totale_Speso
FROM cliente c
JOIN vendita v ON c.id_cliente = v.id_cliente
WHERE c.data_nascita IS NOT NULL
GROUP BY YEAR(c.data_nascita)
ORDER BY Totale_Speso DESC
LIMIT 10;

# Classifica le ore della giornata in base al numero di vendite (in ordine decrescente)
SELECT HOUR(data_ora) AS ora_giorno, COUNT(id_vendita) AS numero_vendite, SUM(prezzo_totale) AS incasso_orario
FROM vendita
GROUP BY HOUR(data_ora)
ORDER BY Incasso_Orario DESC;

# Classifica i giorni della settimana in base al numero di vendite (in ordine decrescente)
SELECT DAYNAME(data_ora) AS Giorno_Settimana, COUNT(id_vendita) AS Numero_Vendite, SUM(prezzo_totale) AS Fatturato_Giornaliero
FROM vendita
GROUP BY DAYNAME(data_ora)
ORDER BY Fatturato_Giornaliero DESC;

# Mostra il numero di vendite ed il fatturato totale mese per mese
SELECT MONTH(data_ora) AS Mese, COUNT(id_vendita) AS Totale_Vendite, SUM(prezzo_totale) AS Incasso_Mensile
FROM vendita
GROUP BY MONTH(data_ora)
ORDER BY Mese ASC;

# Mostra l'età media dei consumatori in base al prodotto ed al genere
SELECT p.nome AS Prodotto, c.genere AS Genere, ROUND(AVG(TIMESTAMPDIFF(YEAR, c.data_nascita, CURDATE())), 0) AS Eta_Media,
	COUNT(v.id_vendita) AS Numero_Acquisti,
    SUM(v.prezzo_totale) AS Fatturato_Generato
FROM vendita v
JOIN prodotto p ON v.id_prodotto = p.id_prodotto
JOIN cliente c ON v.id_cliente = c.id_cliente
WHERE c.genere IS NOT NULL AND c.data_nascita IS NOT NULL
GROUP BY p.id_prodotto, p.nome, c.genere
ORDER BY Prodotto ASC, Fatturato_Generato DESC;

# Classifica in ordine decrescente la combinazione anno di nascita-genere in base al complessivo speso (mostra i primi 10)
SELECT YEAR(c.data_nascita) AS Anno_Nascita, c.genere AS Genere, COUNT(v.id_vendita) AS Numero_Ordini, SUM(v.prezzo_totale) AS Valore_Speso
FROM cliente c
JOIN vendita v ON c.id_cliente = v.id_cliente
WHERE c.data_nascita IS NOT NULL AND c.genere IS NOT NULL
GROUP BY YEAR(c.data_nascita), c.genere
ORDER BY Valore_Speso DESC
LIMIT 10;

# Mostra l'età media dei clienti in base all'orario delle vendite
SELECT HOUR(v.data_ora) AS Ora_Del_Giorno,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, c.data_nascita, CURDATE())), 0) AS Eta_Media_Acquirenti,
    SUM(v.prezzo_totale) AS Incasso_Orario,
    COUNT(v.id_vendita) AS Totale_Vendite
FROM vendita v
JOIN cliente c ON v.id_cliente = c.id_cliente
WHERE c.data_nascita IS NOT NULL
GROUP BY HOUR(v.data_ora)
ORDER BY Ora_Del_Giorno ASC, Incasso_Orario DESC;


# Fatturato medio per tipologia di impresa
SELECT 'Azienda' AS Tipologia_Operatore, ROUND(SUM(v.prezzo_totale) / COUNT(DISTINCT p.id_produttore), 2) AS Fatturato_Medio
FROM produttore p
JOIN vendita v ON p.id_produttore = v.id_produttore
WHERE p.nome_azienda IS NOT NULL AND p.nome_azienda != ''
UNION
SELECT 'Lavoratore Autonomo' AS Tipologia_Operatore, ROUND(SUM(v.prezzo_totale) / COUNT(DISTINCT p.id_produttore), 2) AS Fatturato_Medio
FROM produttore p
JOIN vendita v ON p.id_produttore = v.id_produttore
WHERE p.nome_azienda IS NULL OR p.nome_azienda = '';
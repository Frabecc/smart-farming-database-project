# Leggere la ricetta di un determinato prodotto (in tal caso il Formaggio agli Agrumi) formato da diversi ingredienti.
SELECT pf.nome AS prodotto_finito, pi.nome AS ingrediente, cr.quantita_utilizzata, cr.unita_misura
FROM composizione_ricetta cr
JOIN prodotto pf ON cr.id_prodotto_finito = pf.id_prodotto
JOIN prodotto pi ON cr.id_ingrediente = pi.id_prodotto
WHERE pf.nome = 'Formaggio agli Agrumi';

# Scoprire quali sono gli ingredienti più utilizzati all'interno delle varie ricette.
SELECT p.nome AS ingrediente, 
    COUNT(cr.id_prodotto_finito) AS numero_ricette, 
    SUM(cr.quantita_utilizzata) AS quantita_totale_utilizzata,
    cr.unita_misura
FROM prodotto p
JOIN composizione_ricetta cr ON p.id_prodotto = cr.id_ingrediente
GROUP BY p.id_prodotto, p.nome, cr.unita_misura
ORDER BY numero_ricette DESC, quantita_totale_utilizzata DESC;

# Trovare i 3 clienti che in assoluto hanno speso di più.
SELECT c.nome, c.cognome, c.indirizzo_email, SUM(v.prezzo_totale) AS totale_speso, COUNT(v.id_vendita) AS numero_ordini
FROM cliente c
JOIN vendita v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome, c.indirizzo_email
ORDER BY totale_speso DESC
LIMIT 3;

# Trovare le attività che hanno consumato un totale di 'Acqua' superiore a 100 litri.
SELECT att.id_attivita, pr.cognome AS responsabile,ur.tipo_risorsa, SUM(ur.quantita_usata) AS consumo_totale
FROM attivita att
JOIN produttore pr ON att.id_produttore = pr.id_produttore
JOIN uso_risorsa ur ON att.id_attivita = ur.id_attivita
WHERE ur.tipo_risorsa = 'Acqua'
GROUP BY att.id_attivita, pr.cognome, ur.tipo_risorsa
HAVING SUM(ur.quantita_usata) > 100.00
ORDER BY consumo_totale DESC;

# Calcolare la temperatura media del suolo registrata dai sensori per ogni specifica coltura.
SELECT c.nome AS piantagione, ra.condizione AS parametro_ambientale, ROUND(AVG(ra.misurazione), 2) AS media_registrata
FROM coltura c
JOIN sensore s ON c.id_attivita = s.id_attivita
JOIN rilevazione_ambientale ra ON s.id_sensore = ra.id_sensore
WHERE ra.condizione = 'Temperatura Suolo'
GROUP BY c.id_attivita, c.nome, ra.condizione;

# Elencare tutto il bestiame il cui ultimo controllo veterinario risale a più di 4 mesi fa, o che non è mai stato controllato.
SELECT b.id_attivita, b.specie, b.razza, b.numero_capi, b.data_ultimo_controllo
FROM bestiame b
WHERE DATEDIFF(CURDATE(), b.data_ultimo_controllo) > 120
   OR b.data_ultimo_controllo IS NULL
ORDER BY b.data_ultimo_controllo ASC;
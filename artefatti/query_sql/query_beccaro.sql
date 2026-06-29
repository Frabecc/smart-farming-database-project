USE smart_farming;

#1 Sensori con meno rilevazioni registrate
SELECT
    s.id_sensore,
    s.tipo_sensore,
    s.data_installazione,
    pr.nome_azienda,
    pr.nome,
    pr.cognome,
    COUNT(ra.id_sensore) AS num_rilevazioni,
    MAX(ra.data_ora) AS ultima_rilevazione
FROM sensore s
JOIN attivita a
    ON a.id_attivita = s.id_attivita
JOIN produttore pr
    ON pr.id_produttore = a.id_produttore
LEFT JOIN rilevazione_ambientale ra
    ON ra.id_sensore = s.id_sensore
GROUP BY
    s.id_sensore,
    s.tipo_sensore,
    s.data_installazione,
    pr.nome_azienda,
    pr.nome,
    pr.cognome
ORDER BY num_rilevazioni ASC, ultima_rilevazione ASC
LIMIT 10;

#2 Numero di rilevazioni per condizione da una certa data
SELECT 
    ra.condizione,
    COUNT(*) AS num_rilevazioni
FROM rilevazione_ambientale ra
WHERE ra.data_ora >= '2025-01-01 00:00:00'
GROUP BY ra.condizione
ORDER BY num_rilevazioni DESC;

#3 Prodotti mai venduti (buchi nel catalogo vendite)
SELECT 
    p.id_prodotto,
    p.nome
FROM prodotto p
LEFT JOIN vendita v ON v.id_prodotto = p.id_prodotto
WHERE v.id_prodotto IS NULL
ORDER BY p.nome;


#4 Produttori che non hanno mai venduto nulla
SELECT 
    pr.id_produttore,
    pr.nome_azienda,
    pr.nome,
    pr.cognome
FROM produttore pr
LEFT JOIN vendita v ON v.id_produttore = pr.id_produttore
WHERE v.id_vendita IS NULL
ORDER BY pr.nome_azienda;

#5 Quante risorse diverse usa ogni attività
SELECT 
    a.id_attivita,
    pr.cognome AS responsabile,
    COUNT(DISTINCT ur.tipo_risorsa) AS num_risorse_distinte
FROM attivita a
JOIN produttore pr ON pr.id_produttore = a.id_produttore
JOIN uso_risorsa ur ON ur.id_attivita = a.id_attivita
GROUP BY a.id_attivita, pr.cognome
ORDER BY num_risorse_distinte DESC;

#6 Risorse quasi finite: inventario sotto una soglia (esempio: < 20)
SELECT
    pr.nome_azienda,
    ir.tipo_risorsa,
    ir.quantita_disponibile,
    ir.unita_misura
FROM inventario_risorsa ir
JOIN produttore pr ON pr.id_produttore = ir.id_produttore
WHERE ir.quantita_disponibile < 20
ORDER BY ir.quantita_disponibile ASC;
# Smart Farming Database Project

Progetto universitario sviluppato per l'esame di **Basi di Dati** del corso di laurea triennale in **Statistica per i Big Data** presso l'**Università degli Studi di Salerno**.

Il progetto riguarda la progettazione concettuale, logica, fisica e analitica di un sistema informativo per la gestione di un contesto di **Smart Farming**. L'obiettivo è rappresentare una realtà agricola moderna in cui produttori, colture, bestiame, sensori, risorse, scorte, prodotti, clienti e vendite vengono gestiti in modo integrato attraverso un database relazionale, una componente NoSQL e strumenti di analisi dei dati.

Il sistema è stato progettato per supportare sia la gestione operativa quotidiana dell'attività agricola, sia l'analisi dei dati a supporto delle decisioni tramite query SQL, MongoDB, Data Warehousing, OLAP e dashboard realizzate con Excel/Tableau.

---

## Descrizione del progetto

Il progetto **Smart Farming** simula il funzionamento di una realtà agricola intelligente, nella quale diverse informazioni vengono raccolte, memorizzate e analizzate in modo strutturato.

Il database consente di gestire:

- produttori agricoli;
- colture;
- bestiame;
- attività agricole;
- sensori e rilevazioni ambientali;
- risorse utilizzate nelle attività produttive;
- inventario delle risorse;
- prodotti agricoli;
- prodotti derivati da animali;
- ricette e composizione dei prodotti;
- scorte disponibili;
- clienti;
- vendite.

Il progetto non si limita alla sola implementazione del database, ma include anche una componente analitica pensata per osservare l'andamento delle vendite, il fatturato, il comportamento dei clienti, l'utilizzo delle risorse e altri indicatori utili alla gestione di un sistema agricolo intelligente.

---

## Obiettivi del progetto

Gli obiettivi principali del progetto sono:

- progettare un modello concettuale tramite diagramma **EER**;
- tradurre il modello concettuale in uno schema relazionale;
- implementare fisicamente il database tramite SQL;
- definire chiavi primarie, chiavi esterne e vincoli di integrità;
- popolare il database con dati coerenti rispetto al dominio scelto;
- realizzare query SQL operative e analitiche;
- utilizzare trigger per automatizzare operazioni sul database;
- rappresentare una parte dei dati anche tramite MongoDB;
- costruire una componente di Data Warehousing;
- sviluppare analisi OLAP e visualizzazioni;
- realizzare semplici programmi Python per interrogare il database tramite menu testuale;
- documentare in modo ordinato gli artefatti prodotti durante le varie fasi del lavoro.

---

## Struttura della repository

La repository contiene la relazione finale, lo script SQL principale e tutti gli artefatti prodotti durante le fasi di progettazione, implementazione e analisi.

```text
progetto_smart_farming/
│
├── progetto.pdf
├── progetto.sql
│
└── artefatti/
    │
    ├── diagramma_eer/
    │   ├── diagramma_eer.drawio
    │   └── diagramma_eer.jpg
    │
    ├── composite_usage_map/
    │   ├── composite_usage_map.drawio
    │   └── composite_usage_map.jpg
    │
    ├── progettazione_database/
    │   ├── codice_progettazione.sql
    │   └── codici_popolamento/
    │
    ├── query_sql/
    │   ├── query_beccaro.sql
    │   ├── query_merola.sql
    │   └── query_scianni.sql
    │
    ├── trigger/
    │   └── trigger.sql
    │
    ├── mongodb/
    │   ├── collection_popolamento_(vendita).csv
    │   └── collection_popolamento_(vendita).json
    │
    ├── star_schema/
    │   ├── star_schema_vendite.drawio
    │   └── star_schema_vendite.jpg
    │
    ├── analitiche_data_warehousing/
    │   ├── query_data_warehousing.sql
    │   ├── fact_table.csv
    │   ├── olap.xlsx
    │   ├── pivot_table_excel.png
    │   ├── grafici_excel.png
    │   └── dashboard_analitiche.jpeg
    │
    ├── caso_studio/
    │   ├── caso_studio.twb
    │   └── dashboard_caso_studio.png
    │
    └── programmi_python/
        ├── menu_produttore.py
        └── menu_cliente.py
```

---

## File principali

- `progetto.pdf`: relazione finale del progetto, contenente descrizione del dominio, progettazione concettuale, progettazione logica, query, componente MongoDB, analitiche e considerazioni finali.
- `progetto.sql`: script SQL completo che crea lo schema `smart_farming`, crea le tabelle e inserisce i dati di popolamento.
- `artefatti/diagramma_eer/`: contiene il diagramma EER in formato modificabile `.drawio` e immagine esportata `.jpg`.
- `artefatti/composite_usage_map/`: contiene la Composite Usage Map utilizzata per stimare volumi e frequenze di accesso.
- `artefatti/progettazione_database/codice_progettazione.sql`: script dedicato alla sola creazione dello schema e delle tabelle.
- `artefatti/progettazione_database/codici_popolamento/`: contiene gli script separati per il popolamento delle singole tabelle.
- `artefatti/query_sql/`: contiene le query SQL realizzate dai componenti del gruppo.
- `artefatti/trigger/trigger.sql`: contiene il trigger per l'aggiornamento automatico delle scorte.
- `artefatti/mongodb/`: contiene i file CSV e JSON utilizzati per la parte MongoDB.
- `artefatti/star_schema/`: contiene lo star schema relativo alle vendite.
- `artefatti/analitiche_data_warehousing/`: contiene query analitiche, fact table, file OLAP, pivot table, grafici e dashboard.
- `artefatti/caso_studio/`: contiene il caso studio sviluppato tramite Tableau.
- `artefatti/programmi_python/`: contiene programmi Python con menu testuale per interrogare il database.

---

## Progettazione concettuale

La progettazione concettuale è stata realizzata tramite un diagramma **EER**. L'obiettivo del modello concettuale è rappresentare in modo chiaro le entità principali del dominio e le relazioni tra esse, indipendentemente dagli aspetti implementativi.

Tra le scelte progettuali principali rientrano:

- la modellazione dei produttori agricoli;
- la distinzione tra colture e bestiame;
- la gestione delle attività agricole;
- l'inserimento di sensori e rilevazioni ambientali;
- la rappresentazione delle risorse e del loro utilizzo;
- la gestione dei prodotti e delle scorte;
- la specializzazione dei prodotti in prodotti agricoli e derivati animali;
- la modellazione delle vendite;
- l'introduzione della composizione delle ricette.

Una scelta rilevante riguarda la gerarchia dei prodotti. L'entità generale `prodotto` è stata specializzata in:

- `agricolo`;
- `derivato_animale`.

Questa soluzione consente di mantenere separati attributi e vincoli specifici delle due tipologie di prodotto, migliorando la chiarezza del modello, la normalizzazione e l'integrità referenziale.

---

## Progettazione logica e fisica

Il modello EER è stato tradotto in uno schema relazionale, definendo:

- tabelle;
- attributi;
- chiavi primarie;
- chiavi esterne;
- vincoli di integrità;
- relazioni uno-a-molti e molti-a-molti;
- tabelle associative;
- specializzazioni;
- controlli di consistenza.

La progettazione fisica è stata implementata tramite script SQL. Il file principale per la ricostruzione completa del database è:

```text
progetto.sql
```

Questo script crea lo schema `smart_farming`, crea le tabelle principali e inserisce i dati di popolamento.

---

## Importazione del database MySQL

### Metodo consigliato: importazione tramite script unico

Il modo più semplice per ricostruire il database è utilizzare il file:

```text
progetto.sql
```

Questo file contiene l'intera struttura del database e i dati necessari per il popolamento.

### Procedura con MySQL Workbench

1. Aprire **MySQL Workbench**.
2. Collegarsi al proprio server MySQL locale.
3. Aprire il file:

```text
progetto.sql
```

4. Eseguire l'intero script tramite il pulsante di esecuzione.
5. Verificare che venga creato correttamente lo schema:

```text
smart_farming
```

6. Aggiornare il pannello degli schemi tramite refresh.
7. Controllare che le tabelle siano state create e popolate correttamente.
8. Eseguire eventualmente il file del trigger:

```text
artefatti/trigger/trigger.sql
```

Il trigger è mantenuto in un file separato per permettere una gestione più chiara della logica automatizzata.

---

## Metodo alternativo: script separati

In alternativa allo script unico, è possibile ricostruire il database eseguendo separatamente lo script di progettazione e gli script di popolamento.

Il primo file da eseguire è:

```text
artefatti/progettazione_database/codice_progettazione.sql
```

Questo script crea lo schema e tutte le tabelle del database.

Successivamente è necessario eseguire gli script di popolamento rispettando l'ordine delle dipendenze tra chiavi primarie e chiavi esterne.

Ordine consigliato:

```text
1. produttore.sql
2. cliente.sql
3. risorsa.sql
4. prodotto.sql
5. attivita.sql
6. coltura.sql
7. bestiame.sql
8. sensore.sql
9. rilevazione_ambientale.sql
10. inventario_risorsa.sql
11. uso_risorsa.sql
12. agricolo.sql
13. derivato_animale.sql
14. composizione_ricetta.sql
15. scorta.sql
16. vendita.sql
17. trigger.sql
```

È importante rispettare questo ordine perché alcune tabelle dipendono da altre tramite chiavi esterne.

---

## Query SQL

Le query SQL si trovano nella cartella:

```text
artefatti/query_sql/
```

Sono presenti query realizzate dai componenti del gruppo:

```text
query_beccaro.sql
query_merola.sql
query_scianni.sql
```

Le interrogazioni coprono diversi aspetti del sistema, tra cui:

- analisi dello stato del bestiame;
- prodotti preferiti dai clienti;
- fatturato generato dai produttori;
- consumo delle risorse;
- controllo e gestione delle scorte;
- rilevazioni ambientali;
- analisi delle vendite;
- individuazione di prodotti mai venduti;
- ricette e ingredienti utilizzati.

Le query sono state pensate sia per scopi operativi, quindi legati alla gestione quotidiana del sistema, sia per scopi analitici, quindi orientati alla valutazione delle performance.

---

## Trigger

Il progetto include un trigger SQL contenuto nel file:

```text
artefatti/trigger/trigger.sql
```

Il trigger viene eseguito dopo l'inserimento di una nuova vendita e permette di aggiornare automaticamente la quantità disponibile nella tabella delle scorte.

In particolare, il trigger:

- intercetta l'inserimento di una vendita;
- individua il prodotto venduto;
- sottrae dalla scorta la quantità venduta;
- aggiorna la data dell'ultimo aggiornamento della scorta.

Questa logica consente di mantenere maggiore coerenza tra vendite e disponibilità dei prodotti.

---

## MongoDB

Il progetto include anche una componente NoSQL realizzata tramite MongoDB.

La parte MongoDB è basata sui dati relativi alle vendite e si trova nella cartella:

```text
artefatti/mongodb/
```

I file disponibili sono:

```text
collection_popolamento_(vendita).csv
collection_popolamento_(vendita).json
```

Il file JSON può essere utilizzato per importare la collezione all'interno di MongoDB Compass o MongoDB Shell.

### Importazione in MongoDB Compass

1. Aprire **MongoDB Compass**.
2. Creare o selezionare un database.
3. Creare una nuova collection dedicata alle vendite.
4. Selezionare l'opzione di importazione dati.
5. Caricare il file:

```text
collection_popolamento_(vendita).json
```

6. Verificare che i documenti siano stati importati correttamente.
7. Eseguire le query MongoDB previste dal progetto.

La componente MongoDB consente di rappresentare i dati in formato documentale e di confrontare l'approccio NoSQL con quello relazionale.

---

## Programmi Python

Nella cartella:

```text
artefatti/programmi_python/
```

sono presenti due programmi Python:

```text
menu_produttore.py
menu_cliente.py
```

I programmi permettono di interrogare il database tramite un semplice menu testuale.

Prima dell'esecuzione è necessario controllare i parametri di connessione al database, in particolare:

- host;
- user;
- password;
- nome del database.

Per installare la libreria necessaria alla connessione con MySQL:

```bash
pip install mysql-connector-python
```

Successivamente è possibile eseguire i programmi Python da terminale:

```bash
python menu_produttore.py
```

oppure:

```bash
python menu_cliente.py
```

---

## Data Warehousing e OLAP

La componente analitica del progetto è organizzata principalmente nelle cartelle:

```text
artefatti/star_schema/
artefatti/analitiche_data_warehousing/
artefatti/caso_studio/
```

Lo **star schema** è stato costruito considerando le vendite come fatto principale del sistema.

La cartella `star_schema` contiene:

```text
star_schema_vendite.drawio
star_schema_vendite.jpg
```

La cartella `analitiche_data_warehousing` contiene:

```text
query_data_warehousing.sql
fact_table.csv
olap.xlsx
pivot_table_excel.png
grafici_excel.png
dashboard_analitiche.jpeg
```

Questi file sono stati utilizzati per analizzare i dati da una prospettiva decisionale, osservando aspetti come:

- andamento delle vendite;
- fatturato;
- comportamento dei clienti;
- performance dei produttori;
- distribuzione dei prodotti venduti;
- indicatori utili alla gestione aziendale.

---

## Tableau e caso studio

La cartella:

```text
artefatti/caso_studio/
```

contiene il caso studio realizzato con Tableau.

Sono presenti:

```text
caso_studio.twb
dashboard_caso_studio.png
```

Il file `.twb` può essere aperto con Tableau o Tableau Public. L'immagine `.png` permette invece di visualizzare rapidamente il risultato finale senza aprire il software.

La dashboard è stata utilizzata per rappresentare graficamente alcune informazioni rilevanti del sistema Smart Farming e per facilitare l'interpretazione dei dati.

---

## Composite Usage Map

La Composite Usage Map è contenuta nella cartella:

```text
artefatti/composite_usage_map/
```

Sono presenti:

```text
composite_usage_map.drawio
composite_usage_map.jpg
```

La mappa è stata utilizzata per stimare:

- i volumi delle principali tabelle;
- la frequenza delle operazioni;
- gli accessi giornalieri;
- il comportamento atteso del database;
- possibili scelte di ottimizzazione fisica.

Questo artefatto supporta la fase di progettazione fisica, aiutando a comprendere quali tabelle e operazioni risultano più rilevanti nel sistema.

---

## Tecnologie utilizzate

- SQL
- MySQL
- MySQL Workbench
- MongoDB
- MongoDB Compass
- Python
- mysql-connector-python
- Tableau
- Excel
- Draw.io
- Data Warehousing
- OLAP
- EER Modelling
- Relational Database Design

---

## Competenze sviluppate

Durante il progetto sono state sviluppate competenze relative a:

- progettazione concettuale di basi di dati;
- modellazione EER;
- progettazione logica relazionale;
- progettazione fisica;
- normalizzazione;
- vincoli di integrità;
- query SQL;
- join, aggregazioni e sottoquery;
- trigger;
- gestione delle scorte;
- modellazione NoSQL;
- MongoDB;
- Data Warehousing;
- OLAP;
- Tableau;
- documentazione tecnica;
- lavoro di gruppo;
- presentazione orale e discussione delle scelte progettuali.

---

## Team e contributi

Progetto universitario realizzato in gruppo.

Componenti:

- Francesco Pio Beccaro
- Merola
- Scianni

Il contributo personale di **Francesco Pio Beccaro** è documentato in particolare nel file:

```text
artefatti/query_sql/query_beccaro.sql
```

Oltre alla parte individuale, il progetto è stato sviluppato come lavoro collaborativo, includendo discussione del dominio, progettazione del modello, organizzazione degli artefatti, analisi dei dati e preparazione della documentazione finale.

---

## Note finali

Il progetto integra progettazione concettuale, progettazione logica, implementazione SQL, popolamento del database, interrogazioni SQL, MongoDB, Data Warehousing, analisi OLAP, dashboard e programmi Python.

L'obiettivo complessivo è mostrare come un sistema di Smart Farming possa essere rappresentato attraverso una base di dati strutturata, integrando strumenti operativi e analitici per supportare sia la gestione quotidiana sia l'analisi dei dati.

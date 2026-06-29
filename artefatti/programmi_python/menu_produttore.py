import mysql.connector
from mysql.connector import Error

### per la connessione al databse è necessario inserire la password

def connetti_database():
    try:
        connessione = mysql.connector.connect(
            host='localhost',
            database='smart_farming',
            user='root',
            password=''
        )
        if connessione.is_connected():
            return connessione
    except Error as e:
        print("Errore durante la connessione al MySQL", e)
    return None

def stampa_risultati(cursor):
    risultati = cursor.fetchall()
    if risultati:
        nomi_colonne = [descrizione[0] for descrizione in cursor.description]
        
        for nome_colonna in nomi_colonne:
            print(f"{nome_colonna:<25}", end='')
        print("\n" + "-" * 25 * len(nomi_colonne))
        
        for riga in risultati:
            for valore in riga:
                print(f"{str(valore):<25}", end='')
            print()
    else:
        print("Nessun dato trovato per questo ID.")


def mostra_top_5_prodotti(connessione):
    id_produttore = input("Inserisci il tuo ID Produttore: ")
    query = """
        SELECT p.nome AS Nome_Prodotto, SUM(v.prezzo_totale) AS Fatturato_Totale
        FROM vendita v
        JOIN prodotto p ON v.id_prodotto = p.id_prodotto
        WHERE v.id_produttore = %s
        GROUP BY p.id_prodotto, p.nome
        ORDER BY Fatturato_Totale DESC
        LIMIT 5;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_produttore,))
        print(f"\n--- I TUOI 5 PRODOTTI PIÙ VENDUTI ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()


def controlla_scorte_in_esaurimento(connessione):
    id_produttore = input("Inserisci il tuo ID Produttore: ")
    query = """
        SELECT 
            p.nome AS Nome_Prodotto, 
            s.quantita_disponibile AS Quantità_Residua,
            s.unita_misura AS Unità_di_Misura
        FROM scorta s
        JOIN prodotto p ON s.id_prodotto = p.id_prodotto
        WHERE s.id_produttore = %s AND s.quantita_disponibile < 20.00
        ORDER BY s.quantita_disponibile ASC;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_produttore,))
        print(f"\n--- ALERT: SCORTE IN ESAURIMENTO (Sotto le 20 unità) ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()


def incassi_per_mese_anno(connessione):
    id_produttore = input("Inserisci il tuo ID Produttore: ")
    anno = input("Inserisci l'anno di interesse (es. 2026): ")
    mese = input("Inserisci il mese (da 1 a 12): ")
    
    query = """
        SELECT SUM(prezzo_totale) AS Incasso_Totale, COUNT(id_vendita) AS Numero_Vendite
        FROM vendita
        WHERE id_produttore = %s AND YEAR(data_ora) = %s AND MONTH(data_ora) = %s;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_produttore, anno, mese))
        
        print(f"\n--- RIEPILOGO FINANZIARIO ({mese}/{anno}) ---")
        risultato = cursor.fetchone()
        
        incasso = risultato[0] if risultato[0] is not None else 0.00
        vendite = risultato[1]
        
        print(f"Incasso totale: {incasso} €")
        print(f"Numero di vendite effettuate: {vendite}")
        
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()


def stato_salute_animali(connessione):
    id_produttore = input("Inserisci il tuo ID Produttore: ")
    query = """
        SELECT 
            b.specie AS Specie, 
            b.razza AS Razza,
            b.numero_capi AS Capi_Presenti,
            b.stato_salute AS Stato_Salute,
            b.data_ultimo_controllo AS Data_Ultimo_Controllo
        FROM bestiame b
        JOIN attivita a ON b.id_attivita = a.id_attivita
        WHERE a.id_produttore = %s
        ORDER BY b.data_ultimo_controllo DESC;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_produttore,))
        print(f"\n--- STATO DI SALUTE DEL TUO BESTIAME ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()


def clienti_piu_fedeli(connessione):
    id_produttore = input("Inserisci il tuo ID Produttore: ")
    query = """
        SELECT 
            c.nome AS Nome, 
            c.cognome AS Cognome, 
            COUNT(v.id_vendita) AS Numero_Acquisti,
            SUM(v.prezzo_totale) AS Spesa_Totale,
            c.numero_telefono AS Telefono,
            c.indirizzo_email AS Email
        FROM cliente c
        JOIN vendita v ON c.id_cliente = v.id_cliente
        WHERE v.id_produttore = %s
        GROUP BY c.id_cliente, c.nome, c.cognome
        ORDER BY Numero_Acquisti DESC
        LIMIT 3;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_produttore,))
        print(f"\n--- I TUOI 3 CLIENTI PIÙ FEDELI ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()


def main():
    connessione = connetti_database()
    while True:
        print("\n=== Menu Gestione Smart Farm ===")
        print("1. Mostra i 5 prodotti più venduti (per fatturato)")
        print("2. Controlla scorte in esaurimento (Sotto i 20 Kg/L/Pezzi)")
        print("3. Visualizza incassi totali di un mese specifico")
        print("4. Mostra lo stato di salute di tutti gli animali")
        print("5. Elenco dei clienti più fedeli (Top 3 per numero acquisti)")
        print("6. Esci")
        scelta = input("Scegli un'opzione: ")

        if scelta == '1':
            mostra_top_5_prodotti(connessione)
        elif scelta == '2':
            controlla_scorte_in_esaurimento(connessione)
        elif scelta == '3':
            incassi_per_mese_anno(connessione)
        elif scelta == '4':
            stato_salute_animali(connessione)
        elif scelta == '5':
            clienti_piu_fedeli(connessione)
        elif scelta == '6':
            if connessione.is_connected():
                connessione.close()
                print("Connessione al database chiusa. Arrivederci!")
            break
        else:
            print("Opzione non valida. Riprova.")

if __name__ == "__main__":
    main()
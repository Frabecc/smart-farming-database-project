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
        print("Nessun dato trovato.")

def sfoglia_catalogo(connessione):
    id_produttore = input("Inserisci l'ID del produttore per consultare il suo catalogo: ")
    query = """
        SELECT 
            p.id_prodotto AS ID_Prodotto,
            p.nome AS Nome_Prodotto
        FROM scorta s
        JOIN prodotto p ON s.id_prodotto = p.id_prodotto
        WHERE s.id_produttore = %s
        ORDER BY p.nome ASC;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_produttore,))
        print(f"\n--- CATALOGO DISPONIBILITÀ PRODUTTORE ID {id_produttore} ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()

def storico_ordini(connessione):
    id_cliente = input("Inserisci il tuo ID Cliente: ")
    query = """
        SELECT 
            v.data_ora AS Data_Acquisto,
            p.nome AS Prodotto, 
            v.quantita AS Quantità, 
            v.unita_misura AS Unità, 
            v.prezzo_totale AS Prezzo_Totale,
            pr.nome_azienda AS Azienda
        FROM vendita v
        JOIN prodotto p ON v.id_prodotto = p.id_prodotto
        JOIN produttore pr ON v.id_produttore = pr.id_produttore
        WHERE v.id_cliente = %s
        ORDER BY v.data_ora DESC;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_cliente,))
        print(f"\n--- I TUOI ACQUISTI PASSATI ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()

def riepilogo_spese(connessione):
    id_cliente = input("Inserisci il tuo ID Cliente: ")
    query = """
        SELECT COUNT(id_vendita) AS Totale_Ordini_Effettuati, SUM(prezzo_totale) AS Spesa_Totale
        FROM vendita
        WHERE id_cliente = %s;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (id_cliente,))
        print(f"\n--- IL TUO RIEPILOGO SPESE ---")
        risultato = cursor.fetchone()
        
        ordini = risultato[0]
        spesa = risultato[1] if risultato[1] is not None else 0.00
        
        print(f"Hai effettuato un totale di {ordini} acquisti.")
        print(f"Per un importo complessivo di: {spesa} €")
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()

def best_sellers(connessione):
    query = """
        SELECT p.nome AS Prodotto, COUNT(v.id_vendita) AS Numero_Acquisti
        FROM vendita v
        JOIN prodotto p ON v.id_prodotto = p.id_prodotto
        GROUP BY p.id_prodotto, p.nome
        ORDER BY Numero_Acquisti DESC
        LIMIT 5;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query)
        print(f"\n--- I 5 PRODOTTI PIÙ AMATI DAI NOSTRI CLIENTI ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()

def scopri_ingredienti(connessione):
    nome_prodotto = input("Inserisci il nome del prodotto lavorato (es. 'Formaggio agli Agrumi'): ")
    query = """
        SELECT 
            pi.nome AS Ingrediente, 
            cr.quantita_utilizzata AS Quantità,
            cr.unita_misura AS Unità_di_Misura
        FROM composizione_ricetta cr
        JOIN prodotto pf ON cr.id_prodotto_finito = pf.id_prodotto
        JOIN prodotto pi ON cr.id_ingrediente = pi.id_prodotto
        WHERE pf.nome = %s;
    """
    cursor = connessione.cursor()
    try:
        cursor.execute(query, (nome_prodotto,))
        print(f"\n--- RICETTA TRASPARENTE: {nome_prodotto.upper()} ---")
        stampa_risultati(cursor)
    except Error as e:
        print(f"Errore nella query: {e}")
    finally:
        cursor.close()

def main():
    connessione = connetti_database()
    while True:
        print("\n=== Area Personale Cliente - Smart Farm ===")
        print("1. Sfoglia il catalogo dei prodotti disponibili di un produttore")
        print("2. I tuoi acquisti passati (Storico Ordini)")
        print("3. Il tuo riepilogo spese")
        print("4. I prodotti più amati dai clienti (Best Sellers)")
        print("5. Scopri gli ingredienti di un nostro prodotto lavorato")
        print("6. Esci")
        scelta = input("Scegli un'opzione: ")

        if scelta == '1':
            sfoglia_catalogo(connessione)
        elif scelta == '2':
            storico_ordini(connessione)
        elif scelta == '3':
            riepilogo_spese(connessione)
        elif scelta == '4':
            best_sellers(connessione)
        elif scelta == '5':
            scopri_ingredienti(connessione)
        elif scelta == '6':
            if connessione.is_connected():
                connessione.close()
                print("Connessione al database chiusa. Arrivederci!")
            break
        else:
            print("Opzione non valida. Riprova.")

if __name__ == "__main__":
    main()
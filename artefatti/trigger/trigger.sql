USE smart_farming;

CREATE TRIGGER aggiorna_scorta
AFTER INSERT ON vendita
FOR EACH ROW
UPDATE scorta
SET quantita_disponibile = quantita_disponibile - NEW.quantita, data_aggiornamento = DATE(NEW.data_ora)
WHERE id_produttore = NEW.id_produttore AND id_prodotto = NEW.id_prodotto;
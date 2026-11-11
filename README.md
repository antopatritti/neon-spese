# NEON — Spese sotto controllo

Una PWA in italiano, pensata per iPhone, per registrare le spese e capire dove finiscono i soldi.

## Funzioni
- Inserimento, modifica ed eliminazione delle spese.
- Categorie iniziali e categorie personalizzate.
- Riepilogo mensile, budget, rimanente e media giornaliera.
- Grafico a ciambella per categoria, andamento degli ultimi 7 giorni e confronto degli ultimi 6 mesi.
- Ricerca e filtro dei movimenti.
- Esportazione CSV e backup completo JSON; importazione di CSV e backup JSON.
- Salvataggio locale nel browser e cache offline dopo il primo caricamento.

## Installazione su iPhone
La cartella deve essere pubblicata su un hosting statico con HTTPS (per esempio GitHub Pages o Netlify). Non serve un server applicativo.

1. Pubblica **tutti** i file di questa cartella mantenendo la stessa struttura.
2. Apri l'indirizzo pubblicato con Safari su iPhone.
3. Tocca Condividi → Aggiungi alla schermata Home.
4. Attiva “Apri come app web” quando compare e tocca Aggiungi.

Dopo il primo caricamento, la schermata e i file dell'app sono disponibili anche offline. I dati restano nel browser installato su quel dispositivo: esporta periodicamente il backup JSON. Eliminare i dati del sito o cambiare dispositivo può far perdere i dati non esportati.

## Importazione CSV
Il parser riconosce intestazioni comuni come `data`/`date`, `importo`/`amount`, `descrizione`/`description` e `categoria`/`category`. I formati degli estratti conto bancari possono variare; controlla sempre i movimenti importati. Per un backup completo usa JSON.

## Limiti iOS
Una PWA non può leggere le notifiche di altre app (banca, wallet, PayPal, ecc.). L'app non si collega al conto bancario e non registra automaticamente gli acquisti. Per evitare accessi non autorizzati, non chiede credenziali bancarie.

## Dati e privacy
Non esiste un backend: transazioni, categorie e budget sono conservati nel `localStorage` del browser. Non vengono inviati a un server. Il backup JSON contiene i dati delle spese in chiaro: conservalo in un luogo privato.

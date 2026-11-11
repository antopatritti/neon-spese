# NEON — Spese sotto controllo

PWA in italiano per tracciare le spese, con account personale e sincronizzazione cloud tramite Supabase.

## Architettura
- Frontend statico pubblicabile su GitHub Pages.
- Supabase Auth per account email/password.
- PostgreSQL Supabase per movimenti, categorie e budget.
- Row Level Security (RLS): ogni utente può leggere e modificare esclusivamente le proprie righe.
- Realtime per aggiornare i dispositivi collegati.
- localStorage come cache locale; esportazione JSON/CSV per backup.

## Configurazione Supabase
1. Crea un progetto su https://supabase.com/dashboard.
2. Apri SQL Editor, crea una query e incolla `supabase-schema.sql`. Esegui lo script.
3. In Project Settings → API recupera Project URL e Publishable key (o la legacy anon key).
4. Apri `config.js` e sostituisci i due valori segnaposto:
   - `INSERISCI_SUPABASE_PROJECT_URL`
   - `INSERISCI_SUPABASE_PUBLISHABLE_KEY`
5. Non inserire mai la `service_role` key nel frontend: dà privilegi amministrativi e non deve essere pubblicata.
6. In Authentication → URL Configuration aggiungi l'URL GitHub Pages del repository tra Site URL / Redirect URLs, per esempio `https://TUO-USERNAME.github.io/neon-spese/`.
7. In Authentication → Providers → Email configura la conferma email. Per il primo accesso, crea l'account e conferma l'indirizzo email se richiesto.

## Pubblicazione su GitHub Pages
Carica nella root del repository tutti i file della cartella. In Settings → Pages seleziona Deploy from a branch, `main`, `/(root)`.

## Migrazione dei dati locali
Se questo dispositivo contiene già spese nella vecchia versione locale, dopo il login NEON rileva il database cloud vuoto e chiede se vuoi copiarvi i dati. Prima di migrare, esporta comunque un backup JSON da Impostazioni.

## Installazione su iPhone
Apri il sito con Safari → Condividi → Aggiungi alla schermata Home.

## Sicurezza e limiti
- La Publishable/anon key è destinata al frontend: la sicurezza dipende da RLS, qui attiva su tutte le tabelle.
- Non pubblicare estratti conto, backup o dati finanziari nel repository GitHub.
- Non usare mai la service_role key nel browser.
- NEON non legge notifiche bancarie e non conserva credenziali bancarie.
- La sincronizzazione cloud richiede connessione internet; il service worker conserva l'interfaccia, ma le modifiche offline non sono ancora accodate per un successivo invio.

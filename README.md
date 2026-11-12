# NEON — Spese sotto controllo

PWA in italiano per tracciare le spese, con account personale e sincronizzazione cloud tramite Supabase.

## Architettura
- Frontend statico pubblicabile su GitHub Pages.
- Supabase Auth per account email/password.
- PostgreSQL Supabase per movimenti, categorie e budget.
- Row Level Security (RLS): ogni utente può leggere e modificare esclusivamente le proprie righe.
- Realtime per aggiornare i dispositivi collegati.
- localStorage come cache locale; esportazione JSON/CSV per backup.

## Configurazione Supabase (versione corretta)
1. Crea il progetto su https://supabase.com/dashboard.
2. SQL Editor → New query → incolla `supabase-schema.sql` → Run (si può rieseguire senza danni).
3. Project Settings → API: copia **Project URL** e **Publishable (anon) key** dentro `config.js` (tra gli apici di `url` e `anonKey`). Mai la `service_role`.
4. **Authentication → URL Configuration** (passaggio che causa quasi tutti i problemi con le email):
   - **Site URL** = l'indirizzo esatto del sito, es. `https://TUO-USERNAME.github.io/NOME-REPO/` (NON `localhost:3000`, il valore predefinito).
   - **Redirect URLs** = aggiungi lo stesso indirizzo (anche con `/*` in fondo).
5. **Authentication → Sign In / Providers → Email**: scegli una delle due strade:
   - *Uso personale, il più semplice*: disattiva **Confirm email**. Crei l'account e entri subito, senza email.
   - *Con conferma email*: configura un **SMTP personalizzato** (Authentication → Emails → SMTP Settings, es. Resend o Brevo, gratis). Il server email predefinito di Supabase è solo di prova: pochissime email all'ora e di solito solo agli indirizzi dei membri del progetto, quindi conferma e recupero password spesso non arrivano.
6. Se un account è già bloccato: Authentication → Users → *Add user → Create new user* con **Auto Confirm User** spuntato, oppure elimina l'utente e ricrealo.

## Pubblicazione su GitHub Pages
Carica i file nella root del repository (Settings → Pages → Deploy from a branch → `main` → `/(root)`). Aspetta 1–2 minuti dopo ogni commit.
**Ad ogni modifica incrementa il numero in `sw.js`** (`neon-spese-cache-vN`) così i dispositivi scaricano la versione nuova. Su iPhone, se vedi ancora la versione vecchia: chiudi l'app dal selettore; se non basta, Impostazioni → Safari → Avanzate → Dati dei siti web → elimina il sito e riaggiungilo alla Home.

## Password dimenticata e conferma email
- Login sbagliato → compare il messaggio e il link **Password dimenticata?** (sempre visibile). Arriva un'email: il link riporta al sito, che chiede la nuova password.
- Email di conferma non arrivata → **Reinvia email di conferma** (pausa di 60 secondi tra un invio e l'altro).
- Un link scaduto mostra un avviso e permette di richiederne uno nuovo.

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

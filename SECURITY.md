🔐 SECURITY.md – GhostTrack v2 OS
🛡️ Filosofia di Sicurezza

GhostTrack v2 OS è progettata con un approccio secure-by-default, orientato alla protezione dell’utente, alla resilienza in scenari critici e alla continuità operativa.
La sicurezza non è un’opzione: è il fondamento del sistema.
✅ Principi Fondanti

    Minimizzazione della superficie d’attacco: solo i servizi essenziali sono attivi.

    Cifratura obbligatoria: il disco è cifrato con LUKS2, e le comunicazioni sono protette da protocolli moderni.

    Gestione sicura degli accessi: supporto per MFA, smartcard, password manager offline.

    Sandboxing applicativo: Firejail è integrato per isolare processi potenzialmente rischiosi.

    Firewall preconfigurato: nftables con profili adattivi (pubblico, privato, isolato).

    Audit e logging avanzato: auditd e OSQuery monitorano costantemente lo stato del sistema.

🔍 Monitoraggio e Integrità

Il sistema include strumenti per il controllo continuo:

    OSQuery: interrogazione dello stato del sistema come un database.

    auditd: tracciamento delle attività a livello kernel.

    AIDE: verifica dell’integrità dei file critici.

    Zeek / Wireshark: analisi passiva del traffico di rete (solo su reti autorizzate).

🔒 Comunicazioni Sicure

Civil Resilience OS integra client e protocolli per comunicazioni cifrate:

    Signal Desktop

    Element (Matrix)

    WireGuard / OpenVPN

    mosh per connessioni instabili

⚠️ Responsabilità dell’Utente

L’utente è responsabile dell’uso conforme alle leggi del proprio paese.
GhostTrack v2 OS:

    non include strumenti di attacco o cracking,

    non consente modifiche o fork non autorizzati,

    non può essere distribuita in forma alterata o derivata.

Qualsiasi uso improprio, offensivo o non conforme alla licenza è vietato.
📢 Segnalazioni di Sicurezza

Se rilevi una vulnerabilità o un comportamento anomalo nel sistema, puoi segnalarlo in modo responsabile:

    root.ride@proton.me

    oppure aprendo un issue con tag SECURITY nel repository GitHub

Le segnalazioni saranno gestite con priorità e discrezione.
📄 Licenza e Protezione del Progetto

GhostTrack v2 OS è distribuita sotto licenza proprietaria restrittiva.
È consentito l’uso del sistema nella sua forma originale.
Sono vietati:

    fork

    modifiche al codice

    redistribuzioni alterate

    uso non autorizzato del nome e del logo

Per dettagli, consultare il file LICENSE.txt.

# AnalisiTweet con Sentiment Analysis

In questo Repository si possono trovare tutti i comandi per scaricare tweets e analizzarli con la sentiment analysis ottenendo dei grafici come risultati. 

## Passaggi da svolgere
Inizialmente si scaricano tweets con lo script di python "0_Twitter_API.ipynb.

Si prendono i file .csv scaricati con i tweets e si preparano alle analisi con gli scripts "1_SA_prepare_1file" e "2_SA_prepare_allfiles", così vengono trasformati in file .RData per poter essere analizzati con la sentiment analysis. 

Con lo script "3_SA_2" grazie a syuzhet si effettua una sentiment analysis dei tweets, e come risultato si hanno due modelli di grafici che riportano le 8 emozioni base.

Con lo script "4_SA_advanced_2" grazie a syuzhet si effettua una sentiment analysis dei tweets, e inoltre si va a creare un grafico che mostra in che ora le persone hanno twittato maggiormente. 

All'interno di ogni script è spiegato ogni passaggio che viene svolto per arrivare al risultato. 

# SA_2

library(syuzhet)  # pacchetto per sentiment analysis molto semplificato, 8 emozioni di base di Plutchik
library(tidyverse) # pacchetto per la gestione delle tabelle
library(reshape2)  # pacchetto per la gestione delle tabelle 

# Basic emotions in tweets - Emozioni base con i tweets

# load corpus  -  si prende il file specifico in corpora
load("corpora/TwitterSA1.RData")

# let's find emotional values for one text - prendo il primo tweet e rilevo i valori delle emozioni di base nella frase 
get_nrc_sentiment(my_df$text[1])

# let's add these values to all texts - loop su tutte le recensioni
emotion_values <- data.frame()

# iterate on all texts - inserisco nel database tutti i tweets con le loro emozioni di base
for(i in 1:length(my_df$text)){
  
  emotion_values <- rbind(emotion_values, get_nrc_sentiment(my_df$text[i]))
  if(i %% 100 == 0)
    print(i/length(my_df$text))
  
}

# normalize per text length - aggiungo la lunghezza del testo perchè più il testo è lungo e più le emozioni sono numerose
my_df$length <- lengths(strsplit(my_df$text, "\\W"))

# iterate on all reviews - prendo riga per riga i valori emotivi e li divide per la lunghezza di ognuno dei testi, li normalizza
for(i in 1:length(my_df$text)){
  
  emotion_values[i,] <- emotion_values[i,]/my_df$length[i]
  
}

# then we can unite the dataframes - con cbind si incollano le due tabelle/dataframe
my_df <- cbind(my_df, emotion_values)

# let's pick up two searches to compare?
# searches are already just two!!

my_df$text <- NULL
my_df$length <- NULL

# visualization 1: barplot - grafico a barre SA2_1.1
# calculate means - si crea una riga con tutti i valori medi delle emozioni
my_df_mean <- my_df %>%
  group_by(search) %>%
  summarise_all(list(mean = mean))

# melt dataframe - si prende il dataframe e si divide in tante righe con misurazione, ogni riga ha una singola valutazione dei valori medi. tidyverse = pulito, una riga e un valore. 
my_df_mean <- melt(my_df_mean)

# visualize plot - ggplot comando per creare visualizzazioni in R, prendo il my_df_mean 
p1 <- ggplot(my_df_mean, aes(x=variable, y=value, fill=search))+
  geom_bar(stat="identity", position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
p1
# nel grafico ho tutte e 8 le emozioni base, fill è il colore della colonna.


# visualization 2: boxplot  - grafico SA2_1.2 - vedo tutti i valori di tutti i tweets - è più difficile da interpretare.
# melt dataframe
my_df <- melt(my_df)

# make plot
p2 <- ggplot(my_df, aes(x=variable, y=value, fill=search))+
  geom_boxplot(position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
p2

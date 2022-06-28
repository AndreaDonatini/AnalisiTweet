# SA_prepare_1file

#install.packages("tidyverse") - pacchetto per la gestione delle tabelle
library(tidyverse)

# 1. Twitter

# find files' addresses - cerca il file specifico nella cartella 'corpora' 
twitter_file <- list.files(path = "Corpora", pattern = "tweetsAzzurri1.csv", full.names = T)

# read the first file to prepare the dataframe - legge il file per preparare il dataframe
my_df <- read.csv(twitter_file[1], stringsAsFactors = F)

# get just text and lang - si escludono colonne tenendo testo e lingua
my_df <- my_df[,c("text", "lang")]
my_df$search <- gsub(pattern = "corpora/tweets_", replacement = "", twitter_file[1])

# exclude the "NA" tweets (probably due to errors in the scraping) - tolgo le recensioni NA che non servono
my_df <- my_df[!is.na(my_df$text),]

# some stats - funzione che conta le lingue di tutti i tweets
my_df %>% count(lang)

# reduce to just ita - ridurre solo a lingua italiano
my_df <- my_df %>% filter(lang == "it")

# remove the info on language (now useless) - si rimuove la colonna perchè inutile perchè è già tutto in italiano
my_df$lang <- NULL

#ora ho il dataframe con tutti i tweets solo in italiano

# save all
save(my_df, file = "corpora/TwitterSA1.RData")

#file .RDAta che permette di salvare le variabili di R

# SA_prepare_allfiles

#install.packages("tidyverse") - pacchetto per la gestione delle tabelle
library(tidyverse)

# 2. Twitter

# find files' addresses - cerca i file nella cartella 
twitter_file <- list.files(path = "corpora", pattern = "tweets" , full.names = T)

# read the first file to prepare the dataframe - legge i file per preparare il dataframe
my_df <- read.csv(twitter_file[1], stringsAsFactors = F)

# get just text and lang - si escludono colonne tenendo testo e lingua
my_df <- my_df[,c("text", "lang")]
my_df$search <- gsub(pattern = "corpora/tweets_", replacement = "", twitter_file[1])

# iterate on the other files (if there are) - iterazione che controlla i file aggiungendo altri file
if(length(twitter_file) > 1){
  
  for(i in 2:length(twitter_file)){
    
    # read datasets one by one
    my_tmp_df <- read.csv(twitter_file[i], stringsAsFactors = F)
    my_tmp_df <- my_tmp_df[,c("text", "lang")]
    my_tmp_df$search <- gsub(pattern = "corpora/tweets_", replacement = "", twitter_file[i])
    
    # concatenate
    my_df <- rbind(my_df, my_tmp_df)
    
  }
  
}

# exclude the "NA" tweets (probably due to errors in the scraping) - tolgo le recensioni NA che non servono
my_df <- my_df[!is.na(my_df$text),]

# some stats - funzione che conta le lingue di tutti i tweets
my_df %>% count(lang)

# reduce to just ita - ridurre solo a lingua italiano
my_df <- my_df %>% filter(lang == "it")

# remove the info on language (now useless) - si rimuove la colonna perchè inutile poichè è già tutto in italiano
my_df$lang <- NULL

#ora ho il dataframe con tutti i tweets solo in italiano

# save all
save(my_df, file = "corpora/TwitterSA_all.RData")

#file .RDAta che permette di salvare le variabili di R

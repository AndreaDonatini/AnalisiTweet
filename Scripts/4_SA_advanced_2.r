# SA_advanced_2

# use UDpipe with Italian texts - utilizzo di Udpipe con testi italiani

library(udpipe) # natural language processing library 
library(tidyverse) # pacchetto per la gestione delle tabelle
library(syuzhet) # pacchetto per sentiment analysis molto semplificato, 8 emozioni di base di Plutchik

# read the Italian twitter file into the dataframe - leggo il file selezionato
my_df <- read.csv("Corpora/tweetsAzzurri2.csv", stringsAsFactors = F)

# select just Italian tweets - seleziono solo i tweets in lingua italiana
my_df <- my_df %>% filter(lang == "it")

# convert date of creation into date/time format - si convertono le date dei tweets con strptime
my_df$created_at[1]
class(my_df$created_at[1])

my_df$created_at <- strptime(my_df$created_at, "%Y-%m-%dT%H:%M:%S.000Z", tz = "CET")

my_df$created_at[1]
class(my_df$created_at[1])

# keep just what is relevant - prendo solo il testo e il momento di creazione 
my_df <- my_df[,c("text", "created_at")]

# selezione di 83 tweets
my_df <- my_df[sample(1:length(my_df$text), 83),]  
rownames(my_df) <- 1:length(my_df$text)

# ...dataset preparation complete!

# find models in the resources folder - cerco il modello linguistico per far funzionare il nlp, e uso quello italiano
list.files(path = "resources/udpipe", pattern = ".udpipe", full.names = T)

# load the (italian) model - prendo il modello di udpipe italiano 
udmodel <- udpipe_load_model(file = "resources/udpipe/italian-isdt-ud-2.5-191206.udpipe")

# then process the text - si fa l'annotazione dei tweets
text_annotated <- udpipe(object = udmodel, x = my_df$text, doc_id = rownames(my_df), trace = T)

# now everything is ready to perform (multi-language) SA!

# utilizzo il dizionario creato 
my_dictionary <- read.csv("resources/sentiment_dictionaries/my_SA_dictionary.csv", stringsAsFactors = F)
#View(my_dictionary)

# ora si lavora sul lemma e non sul token, lemma messo in minuscolo
text_annotated$lemma_lower <- tolower(text_annotated$lemma)
# important: if you are working with a language where capital letters are distinctive (e.g. German), then you won't have to lowercase

# to avoid annotating stopwords, limit the analysis to meaningful content words - si lavora su verbi, aggettivi, avverbi e interiazioni
POS_sel <- c("NOUN", "VERB", "ADV", "ADJ", "INTJ") # see more details here: https://universaldependencies.org/u/pos/
text_annotated$lemma_lower[which(!text_annotated$upos %in% POS_sel)] <- NA

# use left_join to add multiple annotations at once - prendo una tabella e aggiungo i valori di un'altra tabella tramite left join 
text_annotated <- left_join(text_annotated, my_dictionary, by = c("lemma_lower" = "word")) 

# now that the sentiment annotation is done, let's keep just the useful info  - si tiene solo l' id e i dati delle emozioni
text_annotated <- text_annotated[c(1,19:length(text_annotated))]
text_annotated$doc_id <- as.numeric(text_annotated$doc_id) 

# replace NAs with zeros - si convertono gli NA con zero
text_annotated <- mutate(text_annotated, across(everything(), ~replace_na(.x, 0)))

View(text_annotated)

# get overall values per tweet - si calcolano i valori per i tweets creando dei gruppi e poi si fa la media
sentences_annotated <- text_annotated %>%
  group_by(doc_id) %>%
  summarise_all(list(valence = mean))

# let's order the tweets by number - si ordinano i tweets per numero
sentences_annotated <- sentences_annotated[order(as.numeric(sentences_annotated$doc_id)),]

# now we can join the annotations to the original dataframe - si uniscono con cbind i nuovi valori al dataframe di partenza
my_df <- cbind(my_df, sentences_annotated[,2:length(sentences_annotated)])
View(my_df)  # si vedono i testi, la data di creazione e la valence, cioè se il valore medio del tweet è positivo o negativo

# then we can re-order the dataframe based on the tweets creation dates - riordino i tweet in ordine di data di creazione 
my_df <- my_df[order(my_df$created_at),]


# put them in a graph
plot(
  my_df$valence, 
  type="l", 
  main="Tweets #Azzurri", 
  xlab = "Time", 
  ylab= "Emotional Valence"
)

# then, let's use the "rolling plot" function from syuzhet (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)

rolling_plot <- function (raw_values, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  return(rolled)
}

my_df$valence <- rolling_plot(my_df$valence)

# line chart
my_df$created_at <- as.POSIXct(my_df$created_at)
p1 <- ggplot(my_df, aes(x=created_at, y=valence)) + 
  geom_line()

p1

# plot SAad.2_2.png - grafico che ci dice quando le persone twittano maggiormente 

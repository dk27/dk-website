install.packages(c("tm", "wordlcoud", "ggplot2", "rvest", "udpipe", "lattice", "igraph", "ggraph"))
library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(rvest)
library(stringr)
library(udpipe)
library(lattice)
library(igraph)
library(ggraph)


# webscrape the following page
text<-read_html("https://www.rev.com/blog/transcripts/donald-trump-joe-biden-final-presidential-debate-transcript-2020")
text1 <- text %>%
  html_nodes("p") %>%
  html_text()

# create three speeches
kristen <- ''
joe <- ''
trump <- ''

for (i in text1)
{
  if(substr(i,1,5)=='Krist') {
    kristen <- c(kristen,paste(str_sub(i, start= gregexpr('\n', i)[[1]][1]+1)))
  }
  
  if(substr(i,1,5)=='Joe B') {
    joe <- c(joe,paste(str_sub(i, start= gregexpr('\n', i)[[1]][1]+1)))
  }
  
  if(substr(i,1,5)=='Donal') {
    trump <- c(trump,paste(str_sub(i, start= gregexpr('\n', i)[[1]][1]+1)))
  }
}

length(joe) 
length(trump) 
### Biden

# create a corpus
c <- VCorpus(VectorSource(joe))

# do some basic data cleaning
txt <- tm_map(c, removeNumbers)
txt <- tm_map(txt, removePunctuation)
txt <- tm_map(txt, stripWhitespace)
txt <- tm_map(txt, content_transformer(tolower))
txt <- tm_map(txt, removeWords, stopwords("english"))
txt <- tm_map(txt, removeWords, c("’re"))

# document term matrix
tdm<-TermDocumentMatrix(txt)
m <- as.matrix(tdm)
words <- sort(rowSums(m), decreasing=TRUE)
words <- words[c(-1,-24, -57, -109, -10)] # remove 're, 'll, 've, don't and didn't as they don't add any value
df <- data.frame(word=names(words), freq=words)
head(df)



#### Trump
# create a corpus
c1 <- VCorpus(VectorSource(trump))

# do some basic data cleaning
#txt1 <- tm_map(c1, removeNumbers)
txt1 <- tm_map(txt1, removePunctuation)
txt1 <- tm_map(txt1, stripWhitespace)
txt1 <- tm_map(txt1, content_transformer(tolower))
txt1 <- tm_map(txt1, removeWords, stopwords("english"))
txt1 <- tm_map(txt1, removeWords, c("’re"))

# document term matrix
tdm1<-TermDocumentMatrix(txt1)
m1 <- as.matrix(tdm1)
words1 <- sort(rowSums(m1), decreasing=TRUE)
words1 <- words1[c(-1,-5, -12, -16, -40)] # remove 're, 'll, 've, don't and didn't 
df1 <- data.frame(word=names(words1), freq=words1)
head(df1)

par(mfrow=c(1,2))
barplot(df[1:15,]$freq, # specify y values
        names.arg=df[1:15,]$word, # specify x values
        las = 2,#rotate x-labels
        col="#10a4d4",
        ylab= "Word Frequencies",
        main = "15 Most Frequent Words Biden")

barplot(df1[1:15,]$freq, # specify y values
        names.arg=df1[1:15,]$word, # specify x values
        las = 2,#rotate x-labels
        col="coral2",ylab= "Word Frequencies",
        main = "15 Most Frequent Words Trump")
par(mfrow=c(1,1))
# generate a word cloud Biden
set.seed(3)
wordcloud(words=df$word, 
          freq = df$freq, 
          min.freq = 5,
          random.order=FALSE,
          colors=brewer.pal(8,'Set1'))

# generate a word cloud Trump
set.seed(3)
wordcloud(words=df1$word, 
          freq = df1$freq, 
          min.freq = 5,
          random.order=FALSE,
          colors=brewer.pal(8,'Set1'))

#### word associations Joe Biden

ud_model <- udpipe_download_model(language="english")
ud_model <- udpipe_load_model(ud_model$file_model)
x <- udpipe_annotate(ud_model, x=joe)
x <- as.data.frame(x)
x$token<-tolower(x$token)
str(x)

# most are verbs followed by nouns
table(x$upos)


# most occurring verbs
verbs <- subset(x, upos %in% c("VERB"))
verbs <- txt_freq(tolower(verbs$token))
verbs$key <- factor(verbs$key, levels=rev(verbs$key))
verbs <- subset(verbs, !key %in% c("’s", "is", "’re") )

# can't say this is very informative
barchart(key~freq,
         data=head(verbs, 20),
         col="#10a4d4",
         main = "Most Occurring Verbs in Biden's Speech",
         xlab = "Freq")

# most occurring nouns
nouns <- subset(x, upos %in% c("NOUN"))
nouns <- txt_freq(nouns$token)
nouns$key <- factor(nouns$key, levels=rev(nouns$key))


barchart(key~freq,
         data=head(nouns, 20),
         col="#10a4d4",
         main = "Most Occurring Nouns in Biden's Speech",
         xlab = "Freq")

# most occurring adjectives
adj <- subset(x, upos %in% c("ADJ"))
adj <- txt_freq(adj$token)
adj$key <- factor(adj$key, levels=rev(adj$key))


barchart(key~freq,
         data=head(adj, 20),
         col="#10a4d4",
         main = "Most Occurring Adjectives in Biden's Speech",
         xlab = "Freq")

# finding keywords
#RAKE
kw <- keywords_rake(x=x, 
                   term="lemma", 
                   group = c("doc_id", "paragraph_id", "sentence_id"), 
                   relevant = x$upos %in% c("NOUN", "ADJ", "VERB" ))
kw$key <- factor(kw$keyword, levels = rev(kw$keyword))
barchart(key ~ rake,
         data = head(subset(kw, freq>3), 15),
         col="#10a4d4",
         main="Key Words")


# visualize as a network
kw1 <- keywords_collocation(x = x, 
                          term = "token", 
                          group = c("doc_id", "paragraph_id", "sentence_id"),
                          ngram_max = 4)

kw1 <- cooccurrence(x$lemma, 
                   relevant = x$upos %in% c("NOUN", "ADJ", "VERB") ,
                   skipgram=1)

head(kw1)
wordnetwork <- head(kw1, 30)
wordnetwork <- graph_from_data_frame(wordnetwork)
ggraph(wordnetwork, layout = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "mediumorchid1") +
  geom_node_text(aes(label = name), col = "#10a4d4", size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Words following one another in a sentence", subtitle = "Nouns, Adjectives & Verbs")

##### Trump
x <- udpipe_annotate(ud_model, x=trump)
x <- as.data.frame(x)
x$token <- tolower(x$token)
str(x)

# most are verbs followed by nouns
table(x$upos)

# most occurring verbs
verbs <- subset(x, upos %in% c("VERB"))
verbs <- txt_freq(verbs$token)
verbs$key <- factor(verbs$key, levels=rev(verbs$key))
verbs <- subset(verbs, !key %in% c("’s", "is", "’re") )

# also not very informative
barchart(key~freq,
         data=head(verbs, 20),
         col="coral2",
         main = "Most Occurring Verbs in Trump's Speech",
         xlab = "Freq")

# most occurring nouns
nouns <- subset(x, upos %in% c("NOUN"))
nouns <- txt_freq(nouns$token)
nouns$key <- factor(nouns$key, levels=rev(nouns$key))


barchart(key~freq,
         data=head(nouns, 20),
         col="coral2",
         main = "Most Occurring Nouns in Trump's Speech",
         xlab = "Freq")

# most occurring adjectives
adj <- subset(x, upos %in% c("ADJ"))
adj <- txt_freq(adj$token)
adj$key <- factor(adj$key, levels=rev(adj$key))


barchart(key~freq,
         data=head(adj, 20),
         col="coral2",
         main = "Most Occurring Adjectives in Trump's Speech",
         xlab = "Freq")

# finding keywords
#RAKE
kw <- keywords_rake(x=x, 
                    term="lemma", 
                    group = c("doc_id", "paragraph_id", "sentence_id"), 
                    relevant = x$upos %in% c("NOUN", "ADJ", "VERB" ))
kw$key <- factor(kw$keyword, levels = rev(kw$keyword))
barchart(key ~ rake,
         data = head(subset(kw, freq>3), 15),
         col='coral2',
         main="Key Words")


# visualize as a network
kw1 <- keywords_collocation(x = x, 
                            term = "token", 
                            group = c("doc_id", "paragraph_id", "sentence_id"),
                            ngram_max = 4)

kw1 <- cooccurrence(x$lemma, 
                    relevant = x$upos %in% c("NOUN", "ADJ", "VERB") ,
                    skipgram=1)

head(kw1)
wordnetwork <- head(kw1, 30)
wordnetwork <- graph_from_data_frame(wordnetwork)
ggraph(wordnetwork, layout = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "mediumorchid1") +
  geom_node_text(aes(label = name), col = "#10a4d4", size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Words following one another in a sentence (Trump)", subtitle = "Nouns, Adjectives & Verbs")

install.packages("easyPubMed")
library(easyPubMed)

my_query <- "colon cancer AND gene NOT review"

myIdlist <- get_pubmed_ids(my_query)

as.integer(as.character(myIdlist$Count))

myIdlist$IdList[[1]]

library(tm)
library(NLP)

mydata <- fetch_pubmed_data(myIdlist, encoding = "ASCII")

df <- table_articles_byAuth(mydata,
                            included_authors = "first",
                            max_chars = 2000,
                            encoding = "ASCII")

names(df)

abstracts <- df$abstract

abstracts %>%
  unnest_tokens(word, text)

install.packages("corpus")
library(corpus)

term_stats(abstracts, drop = stopwords_en, drop_punct = TRUE)

library(Matrix)

corpus <- Corpus(VectorSource(abstracts))

corpus

tdm <- TermDocumentMatrix(corpus, control = list(removePunctuation = TRUE,
                                             stopwords = TRUE))
inspect(tdm[100:110, 1:9])

freq <- sort(colSums(as.matrix(tdm)), decreasing=TRUE)
wordcloud(names(freq), freq, min.freq=400, max.words=Inf, random.order=FALSE, colors=brewer.pal(8, "Accent"), scale=c(7,.4), rot.per=0)

library(easyPubMed)

brca_query <- "breast cancer AND gene NOT review"

prca_query <- "prostate cancer AND gene NOT review"

brca_id <- get_pubmed_ids(brca_query)

prca_id <- get_pubmed_ids(prca_query)

clca_words <- corpus %>%
  unnest_tokens(word, text) %>%
  count(corpus, word, sort = TRUE)

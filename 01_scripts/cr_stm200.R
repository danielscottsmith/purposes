library(igraph)
library(stm)
library(stmCorrViz)
library(feather)
library(wordcloud2)
library(foreign)

# Read in lightly pre-processed data
data <- read.csv("/Volumes/GoogleDrive-107745440581041782819/My Drive/02_Stanford/00_Researching/01_Diss/02_UK/uk_ndigits&no_stops.csv")


# Process data again, but with some algorithms turned off
processed <- textProcessor(data$speech, metadata=data[, c("year", "speaker", "ndigits")], sparselevel=.9999)


# Prep data for STM 
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
docs <- out$documents
vocab <- out$vocab
meta <- out$meta 

# Search for right K

K <- c(50, 75, 100, 125, 150, 175, 200)
documents <- out$documents
vocab <- out$vocab
meta <- out&meta
set.seed(777)
k_results <- searchK(documents, vocab, K, prevalence=~s(year), data=meta, cores=3)

# Run STM, and time it
start_time = Sys.time()
stm200 <-stm(documents = docs, 
             vocab = vocab, 
             K = 200, 
             prevalence =~ s(year), 
             max.em.its = 100, 
             data = meta, 
             init.type = "Spectral")
end_time = Sys.time()


# Structure theta data frame
thetas <- make.dt(model=stm200, meta=meta)
theta_data <- data.frame(stm200$theta, meta)


# Export theta data for later analysis
write.csv(theta_data, "stm200_thetas_b.csv", row.names = FALSE)


# Get top terms per topic, as well as FREX; Export to CSV
topic_terms <- labelTopics(stm200, n=25)
topic_prob <- data.frame(topic_terms[[1]])
topic_frex <- data.frame(topic_terms[[2]])
write.csv(topic_prob, "topics_termsSTM_b.csv", row.names = FALSE)
write.csv(topic_frex, "topics_frexSTM_b.csv", row.names = FALSE)


# Get per-word probs for each topic for later visualization using Python
top_term_probs <- data.frame(stm200$vocab, exp(t(stm200[["beta"]][["logbeta"]][[1]])))
write.csv(top_term_probs, "top_term_probs_b.csv", row.names = FALSE)

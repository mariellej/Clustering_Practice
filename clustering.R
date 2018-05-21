library("RSiteCatalyst")
library("RTextTools")
library("openxlsx");
library("tm")


#set working direcory below:
setwd("C:/Users/marielle.jurist/Documents/Verizon/CRM/search analysis");

##make sure the sheet to load is named "data"

#read file
df = read.xlsx("Search terms 5-15 to 2-26.xlsx", sheet = "data")


wordStem(df$"Search",language = "english")
searches = VectorSource(df$"Search")

searches = Corpus(searches)
searches = tm_map(searches, content_transformer(tolower))
searches = tm_map(searches, removePunctuation)
searches = tm_map(searches, removeWords, stopwords("english"))

tdm = TermDocumentMatrix(searches)


#accumulator for cost results
# cost_df = data.frame()

#run kmeans for all clusters up to 100
# for(i in 1:100){
  #Run kmeans for each level of i, allowing up to 100 iterations for convergence
  # kmeans= kmeans(x=tdm, centers=i, iter.max=1000)
  
  #Combine cluster number and cost together, write to df
  # cost_df= rbind(cost_df, cbind(i, kmeans$tot.withinss))
  
# }
# names(cost_df) = c("cluster", "cost")

#plot clusters vs cost
# qplot(cluster, cost, data=cost_df, geom=c("point","smooth"))

##
#get freq of terms
freq = rowSums(as.matrix(tdm))
# print(freq)

#chose 27 as best cluster number
kmeans27 = kmeans(tdm,27)

# print(kmeans27$cluster)

#match terms with freq and cluster
search_with_cluster = as.data.frame((cbind(kmeans27$cluster, freq)))
search_with_cluster = data.frame(Term = row.names(search_with_cluster), search_with_cluster)

names(search_with_cluster) = c("Term", "Cluster", "Frequency")
rownames(search_with_cluster) = c()
print(search_with_cluster)

write.xlsx(search_with_cluster,"C:/Users/marielle.jurist/Documents/Verizon/CRM/search analysis/kmeans clusters 5-15 to 2-26.xlsx")



require("jsonlite")
require("RCurl")
idf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from SINFOINDUSTRIALA"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rc37495', PASS='orcl_rc37495', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

aldf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from AVG_LOC_SALARY"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rc37495', PASS='orcl_rc37495', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

new_df <- dplyr::right_join(idf,aldf,by="GRP")
##joining the 2 datasets using right_join method. Right join joins datasets by matching rows from a to b

##For the combined data set, We wanted to test income equality between genders.

##first edited dataset by selecting for group, first name, and the actual salary that the employee was paid. 
#new_df %>% select(GRP, FIRST_NAME, ACTUAL_SALARY_PAID)

##Next, we sampled 600 rows of the data using the sample_n() formula to pull out different people.
 new_df_two <- new_df %>% select(GRP, FIRST_NAME, ACTUAL_SALARY_PAID) %>% sample_n(600) %>% filter(ACTUAL_SALARY_PAID != 0) %>% group_by(GRP)

##In addition, because we noticed that some employees had a Paid salary of 0, we further editted the code to removed those people using filter().
new_df_two <- new_df %>% select(GRP, FIRST_NAME, ACTUAL_SALARY_PAID) %>% sample_n(600) %>% filter(ACTUAL_SALARY_PAID != 0) %>% group_by(GRP)

##head of new data frame
head(new_df_two)

##Created a graph to represent the data. Obviously since we can't see these people, we can't tell for sure their gender; however, we can infer their gender based on their name. For instance, someone named "Peter" is highly likely to be male or a "Sarah" will more than likely be female. 
##The idea is to check the names and see what they were paid and compare. If we see that feminine-sounding names were, on average, receiving less compensation than male-sounding names then we can INFER that there was some form of income inequality being exhibited. 

new_df_two %>% sample_n(1) %>% ggplot(aes(x = FIRST_NAME, y = ACTUAL_SALARY_PAID, fill = GRP)) + geom_bar(stat = "identity") + theme(panel.background = element_rect(fill = "black")) + theme(panel.grid.major = element_line(color = "red", linetype = "dotted")) + theme(plot.background = element_rect(fill = "white")) + ggtitle("Is Gender Unfairly Affecting One's Salary?") + theme(plot.title = element_text(color = "steelblue4", size = 20)) + xlab("Employee's First Name") + ylab("Salary") + theme(axis.text.x=element_text(angle=-20,color="black"))

##Colored the graph by group so that not only can we compare by the person's first name then we can also compare within the groups and see if individual's with feminine names were getting paid less than their male counterparts in the same position. For aesthetic reasons, I altered the graph in order to change the x-axis title, y-axis title, graph title, and then added more color to the graph in the background and with the titles.

##Final notes: Because of how the data was joined, it proved difficult to remove all null values hence why "null" is on the graph in both the x and y axis. For analytical purposes, these null-named individuals should be thrown out. 
##Because the data is sampled each time, a new dataset is created. However, the advantage is that you can continuously create trials and keep comparing until a more accurate picture is created. 
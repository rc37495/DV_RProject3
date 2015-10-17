# get required packages
require("dplyr")
require("ggplot2")
require("jsonlite")
require("RCurl")

# read files
industry <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from SINFOINDUSTRIALA"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rc37495', PASS='orcl_rc37495', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
local <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from AVG_LOC_SALARY"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rc37495', PASS='orcl_rc37495', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

# prepare to join tables
local <- local[1:6,]
industry$OVERTIME_PAID <- as.numeric(as.character(industry$OVERTIME_PAID))
local$AVG_LOC_OVERTIME <- as.numeric(as.character(local$AVG_LOC_OVERTIME))
industry_summary <- aggregate(OVERTIME_PAID ~ GRP, industry, mean)
local <- local %>% arrange(desc(AVG_LOC_OVERTIME))

# join tables
combined <- dplyr::inner_join(local, industry_summary, by = "GRP")

# make graph
ggplot(data=combined, aes(x=GRP, y=AVG_LOC_OVERTIME, group=1)) +
  geom_line(colour="blue", size=2) +
  geom_point(colour="blue", size=4, shape=21, fill="black") + 
  geom_line(data=combined, aes(x=GRP, y=OVERTIME_PAID, group=1), colour="dark green", size=2) + 
  geom_point(data=combined, aes(x=GRP, y=OVERTIME_PAID, group=1), colour="dark green", size=4, shape=21, fill="black") +
  labs(title = "Average Overtime Comparison of NY Development Agencies", x = "Job Type", y = "Annual Average Overtime (hours/employee)") + 
  annotate("text", x=5.3, y=1000, colour="blue", label = "Local Companies") + 
  annotate("text", x = 3.7, y = 100, colour="dark green", label = "Industrial Agencies")

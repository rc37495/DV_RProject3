require("dplyr")
require("ggplot2")
require("jsonlite")
require("RCurl")

idf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from SINFOINDUSTRIALA"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rc37495', PASS='orcl_rc37495', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

aldf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from AVG_LOC_SALARY"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rc37495', PASS='orcl_rc37495', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


idf$TOTAL_COMPENSATION <- as.numeric(as.character(idf$TOTAL_COMPENSATION))
aldf$AVG_LOC_OTHER_COMP <- as.numeric(as.character(aldf$AVG_LOC_OTHER_COMP))

dplyr::left_join(idf,aldf,by="GRP") %>% select(GRP,TOTAL_COMPENSATION,AVG_LOC_OTHER_COMP) %>% mutate(DIFFAVG = TOTAL_COMPENSATION - AVG_LOC_OTHER_COMP) %>% filter(GRP == c("Executive","Managerial","Administrative/Clerical","Professional","Operational","Technical/Engineering")) %>% ggplot(aes(x = GRP, y = DIFFAVG, colour = GRP)) + geom_boxplot(fill = "grey") + labs(x="Group",y="Difference from Average of Local Development Compensation") + theme(axis.text.x=element_text(angle=-20,color="black"))

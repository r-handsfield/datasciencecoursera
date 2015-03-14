

cols <- c("STATE", "EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP");
af <- df[,cols];

View( af[with(af, order(-INJURIES, -FATALITIES)),]); View( af[with(af, order(-FATALITIES, -INJURIES)),]);

bf <- aggregate.data.frame(x = af$FATALITIES, by = list(af$EVTYPE), FUN = sum);
cf <- aggregate.data.frame(x = af$INJURIES, by = list(af$EVTYPE), FUN = sum);
names(bf) <- c("evtype", "fatalities");


bf <- aggregate.data.frame(x = list(af$FATALITIES, af$INJURIES), by = list(af$EVTYPE), FUN = sum);
names(bf) <- c("evtype", "fatalities", "injuries");
bf <- bf[with(bf, order(-fatalities)),];




# Bar graph, time on x-axis, color fill grouped by sex -- use position_dodge()
ggplot(data=t, aes(x=evtype, y=casualties, fill=isFatality)) + geom_bar(stat="identity", position=position_dodge()) + theme(axis.text.x = element_text(angle = 90, hjust = 1));


ggplot(data=t[c(2:10, 12:20),], aes(x=evtype, y=casualties, fill=isFatality)) + geom_bar(stat="identity", position=position_dodge()) + theme(axis.text.x = element_text(angle = 90, hjust = 1));


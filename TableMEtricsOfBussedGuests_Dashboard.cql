'Table Metrics of Bussed Guests Dashboard'

-----------------------------------------------------------------
--- Title: 'Rated Bus Guests: Average Table Minutes Per Guest: Last 14 Days'
--- Chart Type:	Column
--- Options: isZoomable, Show Average
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
with distinct(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)-[:RATED_DAILY_BY]->(ra:Rating)
WHERE dr.game_kind = 'TABLE' AND dr.gamingdt = d.gregorian_report_date
WITH collect(toFloat(ra.ratingperiodminutes)) as mins, collect(g.acct_number) as Accts, d
RETURN d.gregorian_report_date as Date, d.gregorian_report_date as tooltip,
round(apoc.math.round(apoc.coll.sum(mins))/size(Accts)) as Average_Rated_Minutes
ORDER BY Date

-----------------------------------------------------------------
--- Title: 'Rated Bus Guests: Played Tables Last 14 Days'
--- Chart Type:	Column
--- Options: isZoomable, Show Average
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
with distinct(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)
WHERE dr.game_kind = 'TABLE' and dr.gamingdt = d.gregorian_report_date
WITH collect(g.acct_number) as collGuests,d
RETURN d.gregorian_report_date as Date, d.gregorian_report_date as tooltip,
size(collGuests) as Rated_Bus_Guests
ORDER BY Date

-----------------------------------------------------------------
--- Title: 'Rated Bus Guests: Popular Table Games: Last 14 Days'
--- Chart Type:	Column
--- Options: isZoomable
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
WITH DISTINCT(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)-[:DAILY_RATED_GAME]->(ga:Games)-[:TYPE_THEME]->(th:Theme)
WHERE dr.gamingdt = d.gregorian_report_date AND dr.game_kind = 'TABLE'
RETURN th.name as TableGame, th.name as tooltip, count(*) as TimesPlayed
ORDER BY TimesPlayed desc

-----------------------------------------------------------------
--- Title: 'Table Rated Minutes: Percentage From Bus Guests: Last 14 Days'
--- Chart Type:	Line
--- Options: isMultiseries, isZoomable, Enable Legend
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
WITH DISTINCT(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)-[:RATED_DAILY_BY]->(ra:Rating)
WHERE dr.game_kind = 'TABLE' AND dr.gamingdt = d.gregorian_report_date
WITH collect(toFloat(ra.ratingperiodminutes)) as bus_mins, d

MATCH (g2:Guest)-[r2:DAILY_RATED]->(dr2:DailyRating)-[:RATED_DAILY_BY]->(ra2:Rating) 
WHERE dr2.gamingdt = d.gregorian_report_date and dr2.game_kind = 'TABLE'
AND not (g2:Guest)-[:BUS]-(:Bus)-[:BUSSED_ON]->(d)
WITH collect(toFloat(ra2.ratingperiodminutes)) as nonbus_mins, bus_mins,d

RETURN d.gregorian_report_date as Date, d.gregorian_report_date as tooltip,
apoc.math.round(apoc.coll.sum(bus_mins)/apoc.coll.sum(apoc.coll.unionAll(nonbus_mins,bus_mins))*100,1) as Bus_Guest_Percentage,
apoc.math.round(apoc.coll.sum(nonbus_mins)/apoc.coll.sum(apoc.coll.unionAll(nonbus_mins,bus_mins))*100,1) as Non_Bus_Guest_Percentage
ORDER BY Date



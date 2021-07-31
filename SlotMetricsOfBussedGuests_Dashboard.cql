'Slot Metrics of Bussed Guests Dashboard'

-----------------------------------------------------------------
--- Title: 'Rated Bus Guest: Average Bet: Last 14 Days'
--- Chart Type:	Column
--- Options: isZoomable, Show Average
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate and d.gregorian_report_date < endDate
WITH distinct(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)
WHERE dr.game_kind = 'SLOT' and dr.gamingdt = d.gregorian_report_date
WITH collect(toFloat(dr.bet)) as bet, collect(toInteger(dr.plays)) as hps,d
RETURN d.gregorian_report_date as Date, d.gregorian_report_date as tooltip,
apoc.math.round(apoc.coll.sum(bet)/apoc.coll.sum(hps),2) as Average_Bet
ORDER BY Date

-----------------------------------------------------------------
--- Title: 'Rated Bus Guest: Popular Slot Themes: Total Rated Play: Last 14 Days'
--- Chart Type:	Column
--- Options: isZoomable, Show Average
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
WITH DISTINCT (g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)-[:DAILY_RATED_GAME]->(ga:Games)-[:TYPE_THEME]->(th:Theme)
WHERE dr.gamingdt = d.gregorian_report_date and dr.game_kind = 'SLOT'
RETURN th.name as Theme, th.name as tooltip, count(*) as TimesPlayed
ORDER BY TimesPlayed desc limit 300

-----------------------------------------------------------------
--- Title: 'Rated Bus Guests: Played Slots Last 14 Days'
--- Chart Type:	Column
--- Options: isZoomable
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -14,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
with distinct(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)
WHERE dr.game_kind = 'SLOT' AND dr.gamingdt = d.gregorian_report_date
WITH collect(g.acct_number) as collGuests,d
RETURN d.gregorian_report_date as Date, d.gregorian_report_date as tooltip,
size(collGuests) as Rated_Bus_Guests
ORDER BY Date

-----------------------------------------------------------------
--- Title: 'Slot Theo Win: Percentage from Rated Bus Guests: 7 Days'
--- Chart Type:	Line
--- Options: isMultiseries, isZoomable, Enable Legend
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
WITH apoc.date.format(apoc.date.add(timestamp(),'ms', -7,'d'),'ms','yyyy-MM-dd')  as startDate,
apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd')  as endDate
MATCH (d:Day)<-[:BUSSED_ON]-(b:Bus)<-[:BUS]-(g:Guest) 
WHERE d.gregorian_report_date >= startDate AND d.gregorian_report_date < endDate
WITH DISTINCT(g),d
MATCH (g)-[r:DAILY_RATED]->(dr:DailyRating)
WHERE dr.game_kind = 'SLOT' and dr.gamingdt = d.gregorian_report_date
WITH collect(toFloat(dr.theorwin)) as bus_twin, d

MATCH (g2:Guest)-[r2:DAILY_RATED]->(dr2:DailyRating) 
WHERE dr2.gamingdt = d.gregorian_report_date and dr2.game_kind = 'SLOT'
and not (g2:Guest)-[:BUS]-(:Bus)-[:BUSSED_ON]->(d)
WITH collect(toFloat(dr2.theorwin)) as nonbus_twin, bus_twin,d

RETURN d.gregorian_report_date as Date, d.gregorian_report_date as tooltip,
apoc.math.round(apoc.coll.sum(bus_twin)/apoc.coll.sum(apoc.coll.unionAll(nonbus_twin,bus_twin))*100,1) as Bus_Guest_Percentage,
apoc.math.round(apoc.coll.sum(nonbus_twin)/apoc.coll.sum(apoc.coll.unionAll(nonbus_twin,bus_twin))*100,1) as Non_Bus_Guest_Percentage
ORDER BY Date





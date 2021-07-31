'Demographics: Rated Bus Guests Dashboard'

-----------------------------------------------------------------
--- Title: 'Bus Rated Guests: Age Distribution: 30 Days'
--- Chart Type:	Column
--- Options: isZoomable
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
MATCH (d:Day)  
WHERE d.gregorian_report_date >= apoc.date.format(apoc.date.add(timestamp(),'ms', -30,'d'),'ms','yyyy-MM-dd', 'America/Los_Angeles') 
and d.gregorian_report_date<= apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd') 
WITH d
MATCH (g:Guest)-[:BUS]->(b:Bus)-[:BUSSED_ON]->(d)  
WITH g
WHERE exists (g.birth_date) and g.birth_date <> ' ' 
RETURN 
date().year - date(g.birth_date).year as Age, 
date().year - date(g.birth_date).year as tooltip, count(*) as Count
ORDER BY Age

-----------------------------------------------------------------
--- Title: 'Bus Rated Guests: Ethnicity: 30 Days'
--- Chart Type:	Pie
--- Options: 
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
MATCH (d:Day)  
WHERE d.gregorian_report_date >= apoc.date.format(apoc.date.add(timestamp(),'ms', -30,'d'),'ms','yyyy-MM-dd','America/Los_Angeles')  
and d.gregorian_report_date<= apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd','America/Los_Angeles')  
WITH d
MATCH (g:Guest)-[:BUS]->(b:Bus)-[:BUSSED_ON]->(d)   
WHERE  g.ethnicity <> '' and g.ethnicity <> 'null' and g.ethnicity<> 'Opt Out' and g.ethnicity <> 'Other'
RETURN distinct g.ethnicity as Ethnicity, g.ethnicity as tooltip, count(*) as Count 
ORDER BY Count desc

-----------------------------------------------------------------
--- Title: 'Bus Rated Guests: Zip Codes: 30 Days'
--- Chart Type:	Column
--- Options: isZoomable
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
MATCH (d:Day)  
WHERE d.gregorian_report_date >= apoc.date.format(apoc.date.add(timestamp(),'ms', -30,'d'),'ms','yyyy-MM-dd','America/Los_Angeles') 
and d.gregorian_report_date<= apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd','America/Los_Angeles') 
WITH d
MATCH (g:Guest)-[:BUS]->(b:Bus)-[:BUSSED_ON]->(d) 
RETURN distinct g.zip_code as Zips, g.zip_code as tooltip, count(*) as Count 
ORDER BY Count desc

-----------------------------------------------------------------
--- Title: 'Bus:Rated Guests Per Bus: 30 Days'
--- Chart Type:	Column
--- Options: isZoomable
--- Refresh: 
--- Description: 
-----------------------------------------------------------------
MATCH (d:Day)  
WHERE d.gregorian_report_date >= apoc.date.format(apoc.date.add(timestamp(),'ms', -30,'d'),'ms','yyyy-MM-dd','America/Los_Angeles')  
and d.gregorian_report_date<= apoc.date.format(apoc.date.add(timestamp(),'ms', -0,'d'),'ms','yyyy-MM-dd','America/Los_Angeles')  
WITH d
MATCH (g:Guest)-[:BUS]->(b:Bus)-[:BUSSED_ON]->(d)  where b.name contains '~PTP~' with 
split(b.name,"~") as bus_ext  where bus_ext[0] <> 'null'
with bus_ext[0] as BusName
RETURN distinct BusName as Bus_Name, BusName as tooltip, count(*) as Guest_Count 
ORDER BY Guest_Count desc






// Query 1

MATCH (c:Crossroad)-[l:Location]->(p:POI)
WITH c, COUNT(*) AS count
WITH MAX(count) AS max
MATCH (c:Crossroad)-[l:Location]->(p:POI)
WITH c, COUNT(*)  AS count, max 
WHERE count = max
WITH c.NodeID AS ID, count AS max
MATCH (c:Crossroad)-[l:Location]->(p:POI)
WHERE c.NodeID = ID 
RETURN c.NodeID AS CrossroadID, max AS MaxPOIs, p.CategoryName AS Category, COUNT(*) AS CountPerCategory
ORDER BY CountPerCategory DESC;


// Query 2

MATCH (p_start:Crossroad{NodeID:10}) -[:Road*]-> (p_end:Crossroad{NodeID:16})
RETURN shortestpath((p_start)-[*]->(p_end));


// Query 3

MATCH (from:Crossroad{NodeID: 10}), (to:Crossroad{NodeID:16}),
path = shortestPath((from)-[:Road*]->(to))
WITH REDUCE(dist = 0, rel in rels(path) | dist + rel.Length) AS Distance, path
RETURN Distance;


// Query 4

MATCH (p_start:Crossroad)-[l:Location]->(poi:POI)
WHERE poi.CategoryName = "bar"
RETURN p_start.NodeID as NodeID, poi.CategoryName as CategoryName, COUNT(*) as NumberOfCrossroads
ORDER BY NumberOfCrossroads DESC
LIMIT 3;


// Query 5

MATCH (p_start:Crossroad{NodeID: 10})-[:Road*]->(p_between: Crossroad{NodeID:17})-[:Road*]->(p_end:Crossroad{NodeID: 21})
RETURN shortestpath((p_start)-[*]->(p_end));


// Query 6

MATCH (p:Crossroad)
RETURN p.NodeID as CrossroadID, round(10.0^3 *sqrt((p.Latitude - 39)^2+(p.Longitude - (-123))^2))/10.0^3 as Distance
ORDER BY Distance DESC
LIMIT 5;
// Rounding to specific decimal points in cypher is tricky! The 
// above workaround was the best solution found!

CREATE TABLE uber_request (
    "Request id" INT PRIMARY KEY,
    "Pickup point" VARCHAR(50),
    "Driver id" VARCHAR(50), 
    "Status" VARCHAR(50),
    "Request timestamp" TIMESTAMP,
    "Drop timestamp" TIMESTAMP,
    "Request Hour" INT,
    "Request Day of Week" VARCHAR(20),
    "Request Month" VARCHAR(20),
    "Trip Duration" REAL
);

SELECT * FROM uber_request;

-- 1. Get the total number of requests:
SELECT COUNT(*) FROM uber_request;

-- Answer : 6745
-- This query counts all rows in the uber_trips table, giving the total number of Uber requests.


-- 2. Find the average trip duration for completed trips:
SELECT AVG("Trip Duration") FROM 
WHERE "Status" = 'Trip Completed';

-- Answer: 52.41
--This query calculates the average trip duration in minutes for completed trips 


-- 3. Count the number of requests by pickup point:
SELECT "Pickup point", COUNT(*) AS TotalRequests FROM uber_request
GROUP BY "Pickup point";

-- Answer: "City"	    3507
--         "Airport"	3238
-- This query groups the requests by Pickup_point and counts the number of requests from each location.


-- 4. Count the number of requests by status:
SELECT "Status", COUNT(*) AS TotalRequests FROM uber_request 
GROUP BY "Status";

-- Answer: "Trip Completed"	 	2831
--         "Cancelled"	     	1264
-- 		   "No Cars Available"	2650
-- This query groups the requests by their Status (e.g., 'Trip Completed', 'Cancelled', 'No Cars Available') and counts how many requests fall into each category.


-- 5. Peak Request Hours and Days of the Week
-- Requests per Hour
SELECT "Request Hour", COUNT(*) AS TotalRequests
FROM uber_request
GROUP BY "Request Hour"
ORDER BY TotalRequests DESC;

-- Answer: 	18	510
--			20	492
			
-- Requests per Day of Week
SELECT "Request Day of Week", COUNT(*) AS TotalRequests
FROM uber_request
GROUP BY "Request Day of Week"
ORDER BY TotalRequests DESC;

-- Answer: "Friday"		1381
--			"Monday"	1367
--			"Thursday"	1353
--			"Wednesday"	1337
--			"Tuesday"	1307
-- Identifies the busiest hours and days for Uber requests, which can help optimize driver availability.

-- 6. Cancellation Rate by Pickup Point
SELECT
    "Pickup point",
    COUNT(*) AS TotalRequests,
    SUM(CASE WHEN "Status" = 'Cancelled' THEN 1 ELSE 0 END) AS TotalCancellations,
    CAST(SUM(CASE WHEN "Status" = 'Cancelled' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(*) AS CancellationRatePercentage
FROM uber_request
GROUP BY "Pickup point"
ORDER BY CancellationRatePercentage DESC;

-- Answer: 	"City"	3507	1066	30.3963501568292
-- 			"Airport"	3238	198	6.114885731933292
-- Highlights locations with high cancellation rates, which might indicate driver unavailability or other issues in those areas.


-- 7. Demand-Supply Gap by Pickup Point (No Cars Available)
SELECT
    "Pickup point",
    COUNT(*) AS TotalNoCarsAvailable
FROM uber_request
WHERE "Status" = 'No Cars Available'
GROUP BY "Pickup point"
ORDER BY TotalNoCarsAvailable DESC;

-- Answer: 	"Airport"	1713
-- 			"City"	937
-- Reveals specific locations where demand is not being met due to a lack of available cars.


-- 8. Breakdown of Trip Statuses by Pickup Point
SELECT
    "Pickup point",
    SUM(CASE WHEN "Status" = 'Trip Completed' THEN 1 ELSE 0 END) AS TripsCompleted,
    SUM(CASE WHEN "Status" = 'Cancelled' THEN 1 ELSE 0 END) AS TripsCancelled,
    SUM(CASE WHEN "Status" = 'No Cars Available' THEN 1 ELSE 0 END) AS NoCarsAvailable,
    COUNT(*) AS TotalRequests
FROM uber_request
GROUP BY "Pickup point"
ORDER BY TotalRequests DESC;

-- Answer: 	"City"		1504	1066	937		3507
--			"Airport"	1327	198		1713	3238
-- Provides a comprehensive view of how different trip statuses (completed, cancelled, no cars) are distributed across various pickup points.


-- 9. Average Trip Duration by Pickup Point for Completed Trips
SELECT
    "Pickup point",
    AVG("Trip Duration") AS AverageTripDurationMinutes
FROM uber_request
WHERE "Status" = 'Trip Completed'
GROUP BY "Pickup point"
ORDER BY AverageTripDurationMinutes DESC;

-- Answer: "City"		52.56
--			"Airport"	52.23
-- Shows if trips from certain pickup points generally take longer or shorter, which can impact driver efficiency or fare calculations.


-- 10. Hourly Demand-Supply Ratio (Completed vs. No Cars Available/Cancelled)
SELECT
    "Request Hour",
    SUM(CASE WHEN "Status" = 'Trip Completed' THEN 1 ELSE 0 END) AS CompletedTrips,
    SUM(CASE WHEN "Status" IN ('Cancelled', 'No Cars Available') THEN 1 ELSE 0 END) AS FailedRequests,
    CAST(SUM(CASE WHEN "Status" = 'Trip Completed' THEN 1 ELSE 0 END) AS REAL) / NULLIF(SUM(CASE WHEN "Status" IN ('Cancelled', 'No Cars Available') THEN 1 ELSE 0 END), 0) AS SuccessToFailureRatio
FROM uber_request
GROUP BY "Request Hour"
ORDER BY "Request Hour";

-- Answer: 	10	116	127	0.91
--			11	115	56	2.05
--			12	121	63	1.92
--			13	89	71	1.25
--			14	88	48	1.83
--			15	102	69	1.47
--  Gives a picture of how well demand is met at different hours. A low ratio might indicate supply shortages.




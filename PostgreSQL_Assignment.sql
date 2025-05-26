-- Active: 1747416600259@@127.0.0.1@5432@assignment

create DATABASE Assignment;

CREATE Table rangers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  contact_info VARCHAR(100) NOT NULL,
  region VARCHAR(50)
);


CREATE Table species (
  id SERIAL PRIMARY KEY,
  common_name VARCHAR(50) NOT NULL,
  scientific_name VARCHAR(100) NOT NULL,
  discovery_date DATE NOT NULL,
  conservation_status VARCHAR(50) 
);

CREATE Table sightings (
  id SERIAL PRIMARY KEY,
  ranger_id INT REFERENCES rangers(id),
  species_id INT REFERENCES species(id),
  location VARCHAR(100) NOT NULL,
  sighting_time TIMESTAMP NOT NULL,
  notes TEXT DEFAULT NULL
);


INSERT INTO rangers (name, contact_info, region)
VALUES
  ('Alice Green', 'alice.green@example.com', 'Northern Hills'),
  ('Bob White', 'bob.white@example.com', 'River Delta'),
  ('Carol King', 'carol.king@example.com', 'Mountain Range'),
  ('Derek Fox', 'derek.fox@example.com', 'Coastal Plains'),
  ('Eva Stone', 'eva.stone@example.com', 'Rainforest Edge'),
  ('Frank Black', 'frank.black@example.com', 'Highland Peaks'),
  ('Grace Moon', 'grace.moon@example.com', 'Desert Outskirts'),
  ('Henry Wood', 'henry.wood@example.com', 'Wetland Zone'),
  ('Isla Dawn', 'isla.dawn@example.com', 'Grassland South'),
  ('Jack Storm', 'jack.storm@example.com', 'Canyon Watch');




SELECT * FROM rangers;


INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES 
  ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
  ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
  ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
  ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');



SELECT * FROM species;


INSERT INTO sightings (ranger_id, species_id, location, sighting_time, notes)
VALUES
  (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
  (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
  (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
  (2, 1, 'Snowfall Pass', '2024-05-18 18:30:00', NULL),
  (1, 4, 'Riverbend', '2024-05-20 14:00:00', 'Herd spotted near water'),
  (4, 1, 'Coastal Marsh', '2024-05-22 10:30:00', 'Nesting activity noticed'),
  (5, 2, 'Rainforest Canopy', '2024-05-25 15:00:00', 'Pair spotted together'),
  (6, 3, 'Highland Valley', '2024-05-28 08:15:00', 'Solo individual sighted'),
  (7, 4, 'Desert Oasis', '2024-06-01 19:45:00', 'Active hunting observed'),
  (8, 1, 'Wetland Fringe', '2024-06-03 12:00:00', 'Hive discovered nearby');



  SELECT * FROM sightings
-- 1.  Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers (name, contact_info, region) 
   VALUES('Derek Fox', 'demo@gmail.com', 'Coastal Plains');

-- 2. Count unique species ever sighted.

SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- 3. Find all sightings where the location includes "Pass".

SELECT * FROM sightings
   WHERE location LIKE '%Pass%';


-- 4.  List each ranger's name and their total number of sightings.


SELECT rangers.name AS ranger_name, COUNT(sightings.id) AS total_num_of_sightings FROM sightings
JOIN rangers ON sightings.ranger_id = rangers.id
GROUP BY rangers.name;


-- 5.  List species that have never been sighted.

SELECT * FROM species
WHERE id NOT IN (SELECT species_id FROM sightings);


-- 6.  Show the most recent 2 sightings.

SELECT * FROM sightings
ORDER BY sighting_time DESC
LIMIT 2;


-- 7. Update all species discovered before year 1800 to have status 'Historic'.

SELECT * FROM species

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';



-- 8. Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT id, ranger_id, species_id, location, sighting_time, notes,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 5 AND 11 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 17 AND 20 THEN 'Evening'
    ELSE 'Night'
  END AS time_of_day
FROM sightings;


-- 9. Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE id NOT IN (
  SELECT  ranger_id FROM sightings
);


SELECT * FROM rangers;

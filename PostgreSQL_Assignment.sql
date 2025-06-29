-- Active: 1747416600259@@127.0.0.1@5432@assignment_2

create DATABASE ASSIGNMENT_2


CREATE TABLE rangers (
  ranger_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  region VARCHAR(50)
);

CREATE TABLE species (
  species_id SERIAL PRIMARY KEY,
  common_name VARCHAR(50) NOT NULL,
  scientific_name VARCHAR(100) NOT NULL,
  discovery_date DATE NOT NULL,
  conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
  sighting_id SERIAL PRIMARY KEY,
  species_id INT REFERENCES species(species_id),
  ranger_id INT REFERENCES rangers(ranger_id),
  location VARCHAR(100) NOT NULL,
  sighting_time TIMESTAMP NOT NULL,
  notes TEXT DEFAULT NULL
);



INSERT INTO rangers (name, region)
VALUES
  ('Alice Green', 'Northern Hills'),
  ('Bob White',  'River Delta'),
  ('Carol King', 'Mountain Range'),
  ('Derek Fox', 'Coastal Plains'),
  ('Eva Stone', 'Rainforest Edge'),
  ('Frank Black', 'Highland Peaks'),
  ('Grace Moon', 'Desert Outskirts'),
  ('Henry Wood', 'Wetland Zone'),
  ('Isla Dawn',  'Grassland South'),
  ('Jack Storm',  'Canyon Watch');


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



SELECT * FROM sightings;






-- 1.  Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers (name, region) 
   VALUES('Derek Fox', 'Coastal Plains');


-- 2. Count unique species ever sighted.

SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- 3. Find all sightings where the location includes "Pass".

SELECT * FROM sightings
   WHERE location LIKE '%Pass%';


-- 4.  List each ranger's name and their total number of sightings.

SELECT rangers.name, COUNT(sightings.sighting_id) AS total_sightings
FROM rangers
LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.name;

-- 5.  List species that have never been sighted.
SELECT species.common_name FROM species
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.sighting_id IS NULL;;



-- 6.  Show the most recent 2 sightings.
SELECT sp.common_name, si.sighting_time, r.name
FROM sightings AS si
JOIN species AS sp ON si.species_id = sp.species_id
JOIN rangers AS r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;


-- 7. Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';



-- 8. Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT sighting_id,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;


-- 9. Delete rangers who have never sighted any species


DELETE FROM rangers
WHERE ranger_id IN (
  SELECT r.ranger_id
  FROM rangers AS r
  LEFT JOIN sightings AS s ON r.ranger_id = s.ranger_id
  WHERE s.ranger_id IS NULL
);

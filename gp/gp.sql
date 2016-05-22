CREATE TABLE raw1 (
    rk text,
    name text,
    country text,
    nick text,
    points double precision,
    sent integer,
    ok integer,
    "time" interval
);

CREATE TABLE raw2 (
    LIKE raw1
);

-- ...

CREATE VIEW combined AS
 SELECT *, 1 AS round FROM raw1
UNION
 SELECT *, 2 AS round FROM raw2;

-- ...

CREATE VIEW ranked AS
 SELECT *,
    rank() OVER (PARTITION BY name ORDER BY points DESC) AS prank
   FROM combined;

CREATE VIEW best4 AS
 SELECT name,
    country,
    sum(points) AS points,
    count(*) AS played
   FROM ranked
  WHERE prank <= 4
  GROUP BY name, country;

CREATE VIEW best4_ranked AS
 SELECT rank() OVER (ORDER BY points DESC) AS rank,
    name,
    country,
    points,
    played
   FROM best4;

CREATE VIEW played5 AS
 SELECT *
   FROM ( SELECT *,
            count(*) OVER (PARTITION BY combined.name) AS played
           FROM combined) played
  WHERE (played = 5);

CREATE VIEW ranked5 AS
 SELECT *,
    rank() OVER (PARTITION BY name ORDER BY points DESC) AS prank
   FROM played5;

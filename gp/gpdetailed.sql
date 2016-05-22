CREATE FUNCTION array_sum(numeric[]) RETURNS numeric
    LANGUAGE sql
    AS $_$
  SELECT sum(unnest) FROM (select unnest($1)) as foo;
$_$;


CREATE TABLE cas1 (
    rk text,
    name text,
    country text,
    nick text,
    points double precision,
    sent integer,
    ok integer,
    "time" interval,
    puzzles integer[]
);

CREATE TABLE cas2 (
    LIKE cas1,
);

CREATE TABLE comp1 (
    LIKE cas1,
);

-- ...

CREATE VIEW dcomb AS
 SELECT '1ca' AS round, * FROM cas1
   FROM cas1
UNION
 SELECT '2ca' AS round, * FROM cas2
UNION
 SELECT '1co' AS round, * FROM comp1;

-- ...

-- simple general leaderboard, without bonus
SELECT name, sum(array_sum(puzzles)) FROM dcomb GROUP BY name ORDER BY sum DESC;

CREATE VIEW playedcasual AS
 SELECT name,
    playedcasual
   FROM ( SELECT name,
            count(*) OVER (PARTITION BY name) AS playedcasual
           FROM dcomb
          WHERE (dcomb.round LIKE '%ca')) cas
  GROUP BY name, playedcasual;
CREATE VIEW playedcomp AS
 SELECT name,
    playedcomp
   FROM ( SELECT name,
            count(*) OVER (PARTITION BY name) AS playedcomp
           FROM dcomb
          WHERE (dcomb.round LIKE '%co')) comp
  GROUP BY name, playedcomp;

CREATE VIEW general AS
 SELECT dcomb.name,
    country,
    nick,
    sum(array_sum(puzzles)) AS points,
    COALESCE(playedcasual.playedcasual, 0) AS casual,
    COALESCE(playedcomp.playedcomp, 0) AS competitive
   FROM dcomb
     LEFT OUTER JOIN playedcasual USING (name)
     LEFT OUTER JOIN playedcomp USING (name)
  GROUP BY dcomb.name, dcomb.country, dcomb.nick, playedcasual.playedcasual, playedcomp.playedcomp;


-- fancy general leaderboard, with number of played rounds of each type
SELECT rank() OVER (ORDER BY points DESC), * from general;

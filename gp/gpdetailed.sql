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

-- general leaderboard, without bonus
SELECT name, sum(array_sum(puzzles)) FROM dcomb GROUP BY name ORDER BY sum DESC;

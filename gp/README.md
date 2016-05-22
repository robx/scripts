Scraping and analyzing puzzle GP results: http://gp.worldpuzzle.org

* scrape.sh parses one of the html result tables from gp.worldpuzzle.org to CSV format
* detailed.awk converts a CSV file for a table that includes per-puzzle points to one with an array of points per puzzle
* gp.sql contains SQL fragments to build overall result tables for the competitive section, based on the non-detailed competitive result tables
* gpdetailed.sql contains SQL fragments that deal with detailed results tables. In particular, these allow building score tables that skip the time bonus.

-- ============================================
-- Oracle DDL Script for NFL Stats Database
-- ============================================

-- Drop existing tables (optional, to reset schema)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE play_by_play CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE weekly_roster CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE weekly_data CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ngs_passing CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ngs_receiving CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ngs_rushing CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE games CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE players CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE teams CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE schedule CASCADE CONSTRAINTS';
    
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- ============================================
-- Players Table
-- ============================================
CREATE TABLE players (
    player_id       NUMBER PRIMARY KEY,
    gsis_id         VARCHAR2(50) UNIQUE,
    full_name       VARCHAR2(100),
    first_name      VARCHAR2(50),
    last_name       VARCHAR2(50),
    position        VARCHAR2(10),
    team            VARCHAR2(10)
);

-- ============================================
-- Games Table
-- ============================================
CREATE TABLE games (
    game_id         NUMBER PRIMARY KEY,
    season          NUMBER,
    week            NUMBER,
    home_team       VARCHAR2(10),
    away_team       VARCHAR2(10),
    game_date       DATE,
    stadium         VARCHAR2(100)
);

-- ============================================
-- Passing Data (NGS)
-- ============================================
CREATE TABLE ngs_passing (
    passing_id          NUMBER PRIMARY KEY,
    player_id           VARCHAR2(50) NOT NULL,
    attempts            NUMBER,
    completions         NUMBER,
    yards               NUMBER,
    touchdowns          NUMBER,
    interceptions       NUMBER,
    air_yards           NUMBER,
    time_to_throw       NUMBER(5,2),
    completion_percent  NUMBER(5,2),
    passer_rating       NUMBER(5,2),
    season              NUMBER,
    week                NUMBER,
    CONSTRAINT fk_pass_player FOREIGN KEY (player_id) REFERENCES players(gsis_id)
);

-- ============================================
-- Receiving Data (NGS)
-- ============================================
CREATE TABLE ngs_receiving (
    receiving_id        NUMBER PRIMARY KEY,
    player_id           VARCHAR2(50) NOT NULL,
    -- game_id             NUMBER NOT NULL,
    receptions          NUMBER,
    targets             NUMBER,
    yards               NUMBER,
    touchdowns          NUMBER,
    air_yards           NUMBER,
    yards_after_catch   NUMBER,
    avg_separation      NUMBER(5,2),
    catch_percent       NUMBER(5,2),
    season              NUMBER,
    week                NUMBER,
    CONSTRAINT fk_recv_player FOREIGN KEY (player_id) REFERENCES players(gsis_id)
    -- CONSTRAINT fk_recv_game FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- ============================================
-- Rushing Data (NGS)
-- ============================================
CREATE TABLE ngs_rushing (
    rushing_id          NUMBER PRIMARY KEY,
    player_id           VARCHAR2(50) NOT NULL,
    -- game_id             NUMBER NOT NULL,
    carries             NUMBER,
    yards               NUMBER,
    touchdowns          NUMBER,
    avg_time_to_line    NUMBER(5,2),
    efficiency          NUMBER(5,2),
    expected_yards      NUMBER,
    season              NUMBER,
    week                NUMBER,
    CONSTRAINT fk_rush_player FOREIGN KEY (player_id) REFERENCES players(gsis_id)
    -- CONSTRAINT fk_rush_game FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- ============================================
-- Play by Play Data
-- ============================================
CREATE TABLE play_by_play (
    pbp_id              NUMBER PRIMARY KEY,
    game_id             NUMBER NOT NULL,
    play_id             NUMBER NOT NULL,
    drive               NUMBER,
    quarter             NUMBER,
    time_remaining      VARCHAR2(10),
    down                NUMBER,
    ytg                 NUMBER,
    yardline            VARCHAR2(20),
    play_type           VARCHAR2(50),
    description         CLOB,
    offense_team        VARCHAR2(10),
    defense_team        VARCHAR2(10),
    passer_id           NUMBER,
    rusher_id           NUMBER,
    receiver_id         NUMBER,
    yards_gained        NUMBER,
    touchdown           CHAR(1),  -- Y/N
    interception        CHAR(1),  -- Y/N
    fumble              CHAR(1),  -- Y/N
    penalty             CHAR(1),  -- Y/N
    penalty_yards       NUMBER,
    season              NUMBER,
    week                NUMBER,
    CONSTRAINT fk_pbp_game FOREIGN KEY (game_id) REFERENCES games(game_id),
    CONSTRAINT fk_pbp_passer FOREIGN KEY (passer_id) REFERENCES players(player_id),
    CONSTRAINT fk_pbp_rusher FOREIGN KEY (rusher_id) REFERENCES players(player_id),
    CONSTRAINT fk_pbp_receiver FOREIGN KEY (receiver_id) REFERENCES players(player_id)
);

-- ============================================
-- Weekly Team Data
-- ============================================
CREATE TABLE weekly_data (
    player_id                VARCHAR2(20),
    player_name              VARCHAR2(100),
    player_display_name      VARCHAR2(100),
    position                 VARCHAR2(10),
    position_group           VARCHAR2(10),
    headshot_url             VARCHAR2(500),
    recent_team              VARCHAR2(10),
    season                   NUMBER(4),
    week                     NUMBER(2),
    season_type              VARCHAR2(10),
    opponent_team            VARCHAR2(10),
    completions              NUMBER,
    attempts                 NUMBER,
    passing_yards            NUMBER,
    passing_tds              NUMBER,
    interceptions            NUMBER,
    sacks                    NUMBER,
    sack_yards               NUMBER,
    sack_fumbles             NUMBER,
    sack_fumbles_lost        NUMBER,
    passing_air_yards        NUMBER,
    passing_yards_after_catch NUMBER,
    passing_first_downs      NUMBER,
    passing_epa              NUMBER(9,6),
    passing_2pt_conversions  NUMBER,
    pacr                     NUMBER(9,6),
    dakota                   NUMBER(9,6),
    carries                  NUMBER,
    rushing_yards            NUMBER,
    rushing_tds              NUMBER,
    rushing_fumbles          NUMBER,
    rushing_fumbles_lost     NUMBER,
    rushing_first_downs      NUMBER,
    rushing_epa              NUMBER(9,6),
    rushing_2pt_conversions  NUMBER,
    receptions               NUMBER,
    targets                  NUMBER,
    receiving_yards          NUMBER,
    receiving_tds            NUMBER,
    receiving_fumbles        NUMBER,
    receiving_fumbles_lost   NUMBER,
    receiving_air_yards      NUMBER,
    receiving_yards_after_catch NUMBER,
    receiving_first_downs    NUMBER,
    receiving_epa            NUMBER(9,6),
    receiving_2pt_conversions NUMBER,
    racr                     NUMBER(9,6),
    target_share             NUMBER(9,6),
    air_yards_share          NUMBER(9,6),
    wopr                     NUMBER(9,6),
    special_teams_tds        NUMBER,
    fantasy_points           NUMBER(9,3),
    fantasy_points_ppr       NUMBER(9,3),
    CONSTRAINT weekly_data_pk PRIMARY KEY (player_id, season, week)
);

alter table weekly_data add (
    game_id varchar2(50)
)

-- alter table weekly_data drop column game_id;

update weekly_data wd
set wd.game_id = (
    select game_id 
      from schedule s
        where s.season = wd.season
        and s.week = wd.week
        and (s.home_team = wd.recent_team 
        and s.away_team = wd.opponent_team
          or s.home_team = wd.opponent_team
            and s.away_team = wd.recent_team)
)
where wd.game_id is null;


-- ============================================
-- Weekly Roster Data
-- ============================================
CREATE TABLE weekly_roster (
    roster_id           NUMBER PRIMARY KEY,
    season              NUMBER NOT NULL,
    week                NUMBER NOT NULL,
    game_id             NUMBER NOT NULL,
    player_id           NUMBER NOT NULL,
    team                VARCHAR2(10),
    position            VARCHAR2(5),
    jersey_number       NUMBER,
    status              VARCHAR2(20),  -- ACTIVE, INACTIVE, IR, etc.
    depth_chart_order   NUMBER,
    date_pulled         TIMESTAMP,
    CONSTRAINT fk_roster_game FOREIGN KEY (game_id) REFERENCES games(game_id),
    CONSTRAINT fk_roster_player FOREIGN KEY (player_id) REFERENCES players(player_id)
);


-- ============================================
-- Teams Table
-- ============================================
CREATE TABLE teams (
    team_id             NUMBER PRIMARY KEY,
    team_abbr           VARCHAR2(10) UNIQUE NOT NULL,
    team_name           VARCHAR2(100),
    team_nick           VARCHAR2(50),
    team_conf           VARCHAR2(10),   -- AFC / NFC
    team_division       VARCHAR2(20),   -- e.g. NFC West
    team_color          VARCHAR2(10),
    team_color2         VARCHAR2(10),
    team_color3         VARCHAR2(10),
    team_color4         VARCHAR2(10),
    team_logo_wikipedia VARCHAR2(500),
    team_logo_espn      VARCHAR2(500),
    team_wordmark       VARCHAR2(500),
    team_conference_logo VARCHAR2(500),
    team_league_logo    VARCHAR2(500),
    team_logo_squared   VARCHAR2(500)
);

-- ============================================
-- Schedule Table
-- ============================================
CREATE TABLE schedule (
    game_id             VARCHAR2(50) PRIMARY KEY,
    season              NUMBER NOT NULL,
    game_type           VARCHAR2(10),   -- REG, POST, PRE
    week                NUMBER,
    gameday             DATE,
    weekday             VARCHAR2(20),
    gametime            VARCHAR2(10),
    
    away_team           VARCHAR2(10) NOT NULL,
    away_score          NUMBER,
    home_team           VARCHAR2(10) NOT NULL,
    home_score          NUMBER,
    
    location            VARCHAR2(50),  -- Home / Away / Neutral
    result              VARCHAR2(10),  -- Win/Loss/Draw
    total               NUMBER,        -- Combined points
    overtime            NUMBER,        -- 0/1
    
    old_game_id         VARCHAR2(50),
    gsis                VARCHAR2(50),
    nfl_detail_id       VARCHAR2(50),
    pfr                 VARCHAR2(50),
    pff                 VARCHAR2(50),
    espn                VARCHAR2(50),
    ftn                 VARCHAR2(50),
    
    away_rest           NUMBER,
    home_rest           NUMBER,
    
    away_moneyline      NUMBER,
    home_moneyline      NUMBER,
    spread_line         NUMBER,
    away_spread_odds    NUMBER,
    home_spread_odds    NUMBER,
    total_line          NUMBER,
    under_odds          NUMBER,
    over_odds           NUMBER,
    
    div_game            NUMBER,  -- 0/1
    roof                VARCHAR2(20),
    surface             VARCHAR2(50),
    temp                NUMBER,
    wind                NUMBER,
    
    away_qb_id          VARCHAR2(50),
    home_qb_id          VARCHAR2(50),
    away_qb_name        VARCHAR2(100),
    home_qb_name        VARCHAR2(100),
    away_coach          VARCHAR2(100),
    home_coach          VARCHAR2(100),
    referee             VARCHAR2(100),
    stadium_id          VARCHAR2(50),
    stadium             VARCHAR2(200),

    -- Relationships
    CONSTRAINT fk_sched_away FOREIGN KEY (away_team) REFERENCES teams(team_abbr),
    CONSTRAINT fk_sched_home FOREIGN KEY (home_team) REFERENCES teams(team_abbr)
);

-- ============================================
-- END OF SCRIPT
-- ============================================

grant select, insert, update, delete on players to wksp_bestbet;
grant select, insert, update, delete on teams to wksp_bestbet;
grant select, insert, update, delete on schedule to wksp_bestbet;
grant select, insert, update, delete on games to wksp_bestbet;
grant select, insert, update, delete on ngs_passing to wksp_bestbet;
grant select, insert, update, delete on ngs_receiving to wksp_bestbet;
grant select, insert, update, delete on ngs_rushing to wksp_bestbet;
grant select, insert, update, delete on play_by_play to wksp_bestbet;
grant select, insert, update, delete on weekly_data to wksp_bestbet;
grant select, insert, update, delete on weekly_roster to wksp_bestbet;
-- commit;
with game_teams as (
    select home_team, away_team, season, week
    from admin.schedule
    where game_id = :P2_GAME_ID
)
select p.* 
from admin.ngs_passing p 
join admin.players pl on p.player_id = pl.gsis_id
join game_teams gt on pl.team in (gt.home_team, gt.away_team) and p.opponent_team in (gt.home_team, gt.away_team)

Below are sample SQL snippets for each report (adjust bind variables, schemas, and field names as needed). They use only columns shown in your DDL. Replace :P_SEASON, :P_WEEK, :P_TEAM, :P_GAME_ID, :P_LOOKBACK with real values or bind variables.

1. Market vs simple model (avg point diff) discrepancy (upcoming week)
````sql
-- Average point differential last N seasons vs current line
with team_hist as (
  select t.team_abbr team,
         avg( case when s.home_team = t.team_abbr then (s.home_score - s.away_score)
                   else (s.away_score - s.home_score) end ) avg_margin
  from admin.teams t
  join admin.schedule s
    on (s.home_team = t.team_abbr or s.away_team = t.team_abbr)
  where s.season between :P_SEASON - 3 and :P_SEASON - 1
    and s.home_score is not null
    and s.away_score is not null
  group by t.team_abbr
),
games as (
  select s.game_id,
         s.season,
         s.week,
         s.home_team,
         s.away_team,
         s.spread_line,          -- usually home spread (- means home favored)
         (spread_line * -1) as model_placeholder -- example placeholder
  from admin.schedule s
  where s.season = :P_SEASON
    and s.week   = :P_WEEK
)
select g.game_id,
       g.away_team,
       g.home_team,
       g.spread_line        as market_spread_home,
       (h.avg_margin - a.avg_margin) as simple_model_edge,  -- positive => home projected edge
       ( (h.avg_margin - a.avg_margin) - g.spread_line )    as discrepancy
from games g
left join team_hist h on h.team = g.home_team
left join team_hist a on a.team = g.away_team
order by abs((h.avg_margin - a.avg_margin) - g.spread_line) desc;
````

2. Pass Rate Over Expectation (neutral downs)
````sql
-- Neutral downs: quarters 1-3, score within 10, downs 1-2
with plays as (
  select season,
         week,
         offense_team,
         case when play_type = 'PASS' then 1 else 0 end is_pass
  from admin.play_by_play
  where quarter between 1 and 3
    and abs( (select home_score from admin.schedule s where s.game_id = play_by_play.game_id)
             - (select away_score from admin.schedule s where s.game_id = play_by_play.game_id) ) <= 10
    and down in (1,2)
),
league as (
  select avg(is_pass) league_neutral_pass_rate
  from plays
)
select season, week, offense_team,
       avg(is_pass) team_neutral_pass_rate,
       avg(is_pass) - (select league_neutral_pass_rate from league) as proe
from plays
group by season, week, offense_team
order by season desc, week desc;
````

3. Explosive play differential (20+ pass / 10+ rush)
````sql
with base as (
  select season,
         week,
         offense_team,
         defense_team,
         play_type,
         yards_gained
  from admin.play_by_play
  where yards_gained is not null
),
explosive as (
  select *,
         case
           when play_type = 'PASS' and yards_gained >= 20 then 1
           when play_type = 'RUSH' and yards_gained >= 10 then 1
           else 0
         end is_explosive
  from base
),
team_agg as (
  select season, week, offense_team team,
         sum(is_explosive) expl_plays,
         count(*) total_plays,
         sum(is_explosive)/nullif(count(*),0) expl_rate
  from explosive
  group by season, week, offense_team
),
def_agg as (
  select season, week, defense_team team,
         sum(is_explosive) expl_allowed,
         count(*) plays_def,
         sum(is_explosive)/nullif(count(*),0) expl_allowed_rate
  from explosive
  group by season, week, defense_team
)
select t.season, t.week, t.team,
       t.expl_rate,
       d.expl_allowed_rate,
       (t.expl_rate - d.expl_allowed_rate) net_explosive_diff
from team_agg t
join def_agg d on d.season = t.season and d.week = t.week and d.team = t.team
order by t.season desc, t.week desc, net_explosive_diff desc;
````

4. EPA per drive proxy (using weekly_data passing/rushing/receiving EPA sums)
````sql
select season,
       week,
       recent_team team,
       (sum(passing_epa) + sum(rushing_epa) + sum(receiving_epa)) total_epa,
       sum(passing_epa) passing_epa,
       sum(rushing_epa) rushing_epa,
       sum(receiving_epa) receiving_epa
from admin.weekly_data
group by season, week, recent_team
order by season desc, week desc;
````

5. Pressure mismatch proxy (using sacks / attempts)
````sql
with team_pass as (
  select season, week, recent_team team,
         sum(attempts) attempts,
         sum(sacks) sacks
  from admin.weekly_data
  group by season, week, recent_team
),
pressure as (
  select season, week, team,
         sacks,
         attempts,
         sacks / nullif(attempts + sacks,0) pressure_rate
  from team_pass
),
next_week as (
  select season, week, home_team, away_team
  from admin.schedule
  where season = :P_SEASON
    and week   = :P_WEEK
)
select n.game_id,
       n.home_team,
       h.pressure_rate home_pressure_rate_allowed,
       n.away_team,
       a.pressure_rate away_pressure_rate_allowed,
       (h.pressure_rate - a.pressure_rate) diff_home_minus_away
from admin.schedule n
left join pressure h on h.team = n.home_team and h.season = n.season and h.week = n.week - 1
left join pressure a on a.team = n.away_team and a.season = n.season and a.week = n.week - 1
where n.season = :P_SEASON
  and n.week = :P_WEEK;
````

6. Early-down success & pace (success = gain >= ytg or touchdown)
````sql
with ed as (
  select game_id,
         offense_team,
         season,
         week,
         case when (yards_gained >= ytg) or touchdown = 'Y' then 1 else 0 end success,
         1 play_cnt
  from admin.play_by_play
  where down in (1,2)
),
team_ed as (
  select season, week, offense_team team,
         sum(success) successes,
         count(*) plays,
         sum(success)/nullif(count(*),0) success_rate
  from ed
  group by season, week, offense_team
),
pace as (
  select season, week, offense_team team,
         count(*) total_offensive_plays
  from admin.play_by_play
  group by season, week, offense_team
)
select p.season, p.week, p.team,
       t.success_rate,
       p.total_offensive_plays
from pace p
join team_ed t on t.season = p.season and t.week = p.week and t.team = p.team
order by p.season desc, p.week desc, t.success_rate desc;
````

7. Rest / situational matrix
````sql
select season,
       week,
       game_id,
       home_team,
       away_team,
       home_rest,
       away_rest,
       (home_rest - away_rest) rest_diff,
       roof,
       surface,
       overtime
from admin.schedule
where season = :P_SEASON
order by week, game_id;
````

8. Weather / surface impact on air yards (joining schedule with ngs_passing)
````sql
with pass_air as (
  select p.season,
         p.week,
         pl.team,
         sum(p.air_yards) air_yards,
         sum(p.attempts) attempts
  from admin.ngs_passing p
  join admin.players pl on pl.gsis_id = p.player_id
  group by p.season, p.week, pl.team
),
sched as (
  select season, week, game_id, home_team, away_team, roof, surface, temp, wind
  from admin.schedule
  where season between :P_SEASON - :P_LOOKBACK and :P_SEASON
)
select s.season,
       s.week,
       s.roof,
       s.surface,
       s.temp,
       s.wind,
       t.team,
       t.air_yards / nullif(t.attempts,0) avg_air_yards
from sched s
join pass_air t on t.season = s.season and t.week = s.week
where t.team in (s.home_team, s.away_team);
````

9. Player receiving usage vs opponent defense allowance (last N weeks)
````sql
with recent_player as (
  select r.player_id,
         pl.full_name,
         pl.team,
         r.season,
         r.week,
         r.targets,
         r.receptions,
         r.yards
  from admin.ngs_receiving r
  join admin.players pl on pl.gsis_id = r.player_id
  where r.season = :P_SEASON
    and r.week between :P_WEEK - :P_LOOKBACK and :P_WEEK - 1
),
player_agg as (
  select player_id,
         full_name,
         team,
         avg(targets) avg_targets,
         avg(receptions) avg_receptions,
         avg(yards) avg_yards
  from recent_player
  group by player_id, full_name, team
),
def_allow as (
  select r.season,
         r.week,
         d.team_def,
         sum(r.yards) yards_allowed,
         sum(r.targets) targets_allowed
  from (
     select n.week,
            n.season,
            case when pl.team = n.home_team then n.away_team else n.home_team end team_def,
            r.targets,
            r.yards
     from admin.schedule n
     join admin.ngs_receiving r
       on r.season = n.season and r.week = n.week
     join admin.players pl
       on pl.gsis_id = r.player_id
     where n.season = :P_SEASON
       and n.week between :P_WEEK - :P_LOOKBACK and :P_WEEK - 1
  ) r
  group by r.season, r.week, r.team_def
),
def_agg as (
  select team_def,
         avg(yards_allowed) avg_recv_yards_allowed,
         avg(targets_allowed) avg_targets_allowed
  from def_allow
  group by team_def
)
select pa.full_name,
       pa.team,
       pa.avg_targets,
       pa.avg_receptions,
       pa.avg_yards,
       da.avg_recv_yards_allowed opponent_avg_yards_allowed
from player_agg pa
left join def_agg da on da.team_def <> pa.team
order by pa.avg_targets desc fetch first 50 rows only;
````

10. Penalty differential
````sql
with pen as (
  select season,
         week,
         offense_team team_off,
         defense_team team_def,
         penalty,
         penalty_yards
  from admin.play_by_play
  where penalty = 'Y'
),
by_team as (
  select season, week, team_off team,
         count(*) penalties_for,
         sum(penalty_yards) yards_for
  from pen
  group by season, week, team_off
),
against as (
  select season, week, team_def team,
         count(*) penalties_against,
         sum(penalty_yards) yards_against
  from pen
  group by season, week, team_def
)
select f.season,
       f.week,
       f.team,
       f.penalties_for,
       a.penalties_against,
       (f.penalties_for - a.penalties_against) net_penalties,
       (f.yards_for - a.yards_against) net_penalty_yards
from by_team f
join against a on a.season = f.season and a.week = f.week and a.team = f.team
order by f.season desc, f.week desc, net_penalty_yards asc;
````

11. Referee / crew tendencies (penalties per game)
````sql
with game_pen as (
  select s.season,
         s.week,
         s.referee,
         count(case when p.penalty = 'Y' then 1 end) penalties,
         sum(case when p.penalty = 'Y' then p.penalty_yards else 0 end) yards
  from admin.schedule s
  left join admin.play_by_play p on p.game_id = s.game_id
  group by s.season, s.week, s.referee
),
agg as (
  select referee,
         count(*) games,
         sum(penalties) total_penalties,
         sum(yards) total_yards,
         sum(penalties)/nullif(count(*),0) avg_penalties_per_game,
         sum(yards)/nullif(count(*),0) avg_penalty_yards_per_game
  from game_pen
  group by referee
)
select *
from agg
where games >= 5
order by avg_penalties_per_game desc;
````

12. Closing line value approximation (compare spread to actual margin)
````sql
select season,
       week,
       game_id,
       home_team,
       away_team,
       spread_line,  -- assumed closing
       (home_score - away_score) as actual_margin,
       ((home_score - away_score) - spread_line) as clv_margin  -- positive = beat market
from admin.schedule
where season between :P_SEASON - 3 and :P_SEASON
  and home_score is not null
  and away_score is not null
order by season desc, week desc;
````



select
    s.game_id,
    s.home_team,
    s.away_team,
    -- a subitle to show the odds for the game
    case when s.away_moneyline > 0 then '+' || s.away_moneyline else to_char(s.away_moneyline) end as away_moneyline,
    case when s.home_moneyline > 0 then '+' || s.home_moneyline else to_char(s.home_moneyline) end as home_moneyline,
    trim(to_char(s.gameday,'Day')) || ' ' || to_char(to_date(s.gametime,'HH24:MI'),'FMHH:MI PM') as gametime, 
    h.team_logo_squared as home_logo,
    a.team_logo_squared as away_logo
from
    admin.schedule s
join admin.teams h on h.team_abbr = s.home_team
join admin.teams a on a.team_abbr = s.away_team
where 
    s.season = 2025
  and s.week = 1
order by
    s.gameday, s.gametime;
/

-- Bind: :P_GAME_ID
with game as (
    select game_id, season, week, home_team, away_team
    from admin.schedule
    where game_id = :P_GAME_ID
),
lb as (
    select season,
           week,
           home_team,
           away_team,
           greatest(1, week - 6) start_week
    from game
),
def_game_yards as (
    -- Each row = what a defense (opponent_team) allowed in a given week
    select wd.season,
           wd.week,
           wd.opponent_team  as defense_team,
           sum(wd.passing_yards)   passing_yards_allowed,
           sum(wd.rushing_yards)   rushing_yards_allowed,
           sum(wd.receiving_yards) receiving_yards_allowed
    from admin.weekly_data wd
    join game g on g.season = wd.season
    where wd.week between (select start_week from lb) and (select week-1 from game)
      and wd.opponent_team in ( (select home_team from game),
                                (select away_team from game) )
    group by wd.season, wd.week, wd.opponent_team
),
agg as (
    select defense_team,
           count(*) games,
           sum(passing_yards_allowed)   pass_yards_total,
           sum(rushing_yards_allowed)   rush_yards_total,
           sum(receiving_yards_allowed) recv_yards_total,
           round(sum(passing_yards_allowed)/nullif(count(*),0),1)   pass_yards_per_game,
           round(sum(rushing_yards_allowed)/nullif(count(*),0),1)   rush_yards_per_game,
           round(sum(receiving_yards_allowed)/nullif(count(*),0),1) recv_yards_per_game
    from def_game_yards
    group by defense_team
)
select case
         when defense_team = (select home_team from game) then 'HOME'
         else 'AWAY'
       end side,
       defense_team           team,
       games,
       pass_yards_total,
       pass_yards_per_game,
       rush_yards_total,
       rush_yards_per_game,
       recv_yards_total,
       recv_yards_per_game
from agg
order by side;


/

with teams as (
    select game_id, season, week, home_team, away_team, gameday
    from admin.schedule
    where game_id = :P_GAME_ID
),
home_team_games as (
    select s.game_id, s.season, s.week, s.home_team, s.away_team, t.home_team as team
    from admin.schedule s
    join teams t on (t.home_team = s.home_team or t.home_team = s.away_team)
    where s.gameday <= (select gameday from teams)
      and game_type = 'REG'
    order by s.gameday desc, s.gametime desc
    fetch first 6 rows only
), 
away_team_games as (
    select s.game_id, s.season, s.week, s.home_team, s.away_team, t.away_team as team
    from admin.schedule s
    join teams t on (t.away_team = s.home_team or t.away_team = s.away_team)
    where s.gameday <= (select gameday from teams)
      and game_type = 'REG'
    order by s.gameday desc, s.gametime desc
    fetch first 6 rows only
), recent_games as (
    select * from home_team_games
    union all
    select * from away_team_games
),
team_game_stats as (
    select rg.team,
           rg.game_id,
           sum(wd.passing_yards)    passing_yards,
           sum(wd.rushing_yards)    rushing_yards,
           sum(wd.receiving_yards)  receiving_yards,
           sum(wd.passing_tds)      passing_tds,
           sum(wd.rushing_tds)      rushing_tds,
           sum(wd.receiving_tds)    receiving_tds
    from recent_games rg
    join admin.weekly_data wd
      on wd.game_id = rg.game_id
     and wd.opponent_team = rg.team
    group by rg.team, rg.game_id
)
select team,
       round(avg(passing_yards),1)      avg_passing_yards_allowed,
       round(avg(rushing_yards),1)      avg_rushing_yards_allowed,
       round(avg(receiving_yards),1)    avg_receiving_yards_allowed,
       round(avg(passing_tds),2)        avg_passing_tds_allowed,
       round(avg(rushing_tds),2)        avg_rushing_tds_allowed,
       round(avg(receiving_tds),2)      avg_receiving_tds_allowed
from team_game_stats
group by team
order by team;

-- last 6 games against each other
with game as (
    select game_id, season, week, home_team, away_team, gameday
    from admin.schedule
    where game_id = :P2_GAME_ID
),
recent_games as (
    select s.game_id, s.season, s.week, s.home_team, s.away_team
    from admin.schedule s
    join game g on (g.home_team = s.home_team and g.away_team = s.away_team)
                  or (g.home_team = s.away_team and g.away_team = s.home_team)
    where s.gameday < (select gameday from game)
      and s.game_type = 'REG'
    order by s.gameday desc, s.gametime desc
    fetch first 6 rows only
)
select rg.game_id,
       rg.season,
       rg.week,
       rg.home_team,
       rg.away_team,
       (select home_score from admin.schedule s where s.game_id = rg.game_id) as home_score,
       (select away_score from admin.schedule s where s.game_id = rg.game_id) as away_score,
       sum(case when wd.opponent_team = rg.home_team then wd.passing_yards else 0 end) as passing_yards_away,
       sum(case when wd.opponent_team = rg.away_team then wd.passing_yards else 0 end) as passing_yards_home,
       sum(case when wd.opponent_team = rg.home_team then wd.rushing_yards else 0 end) as rushing_yards_away,
       sum(case when wd.opponent_team = rg.away_team then wd.rushing_yards else 0 end) as rushing_yards_home,
       sum(case when wd.opponent_team = rg.home_team then wd.passing_tds else 0 end) as passing_tds_away,
       sum(case when wd.opponent_team = rg.away_team then wd.passing_tds else 0 end) as passing_tds_home,
       sum(case when wd.opponent_team = rg.home_team then wd.rushing_tds else 0 end) as rushing_tds_away,
       sum(case when wd.opponent_team = rg.away_team then wd.rushing_tds else 0 end) as rushing_tds_home,
       sum(case when wd.opponent_team = rg.home_team then wd.attempts else 0 end) as passing_attempts_away,
       sum(case when wd.opponent_team = rg.away_team then wd.attempts else 0 end) as passing_attempts_home,
       sum(case when wd.opponent_team = rg.home_team then wd.carries else 0 end) as rushing_attempts_away,
       sum(case when wd.opponent_team = rg.away_team then wd.carries else 0 end) as rushing_attempts_home,
       sum(case when wd.opponent_team = rg.home_team then wd.completions else 0 end) as completions_away,
       sum(case when wd.opponent_team = rg.away_team then wd.completions else 0 end) as completions_home

       ht.primary_color home_color,
       at.primary_color away_color
from recent_games rg
join admin.weekly_data wd on wd.game_id = rg.game_id
join admin.teams ht on ht.team_abbr = rg.home_team
join admin.teams at on at.team_abbr = rg.away_team
where wd.opponent_team in (rg.home_team, rg.away_team)
group by rg.game_id,
       rg.season,
       rg.week,
       rg.home_team,
       rg.away_team
order by rg.season desc, rg.week desc


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
    player_id           NUMBER NOT NULL,
    game_id             NUMBER NOT NULL,
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
    CONSTRAINT fk_pass_player FOREIGN KEY (player_id) REFERENCES players(player_id),
    CONSTRAINT fk_pass_game FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- ============================================
-- Receiving Data (NGS)
-- ============================================
CREATE TABLE ngs_receiving (
    receiving_id        NUMBER PRIMARY KEY,
    player_id           NUMBER NOT NULL,
    game_id             NUMBER NOT NULL,
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
    CONSTRAINT fk_recv_player FOREIGN KEY (player_id) REFERENCES players(player_id),
    CONSTRAINT fk_recv_game FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- ============================================
-- Rushing Data (NGS)
-- ============================================
CREATE TABLE ngs_rushing (
    rushing_id          NUMBER PRIMARY KEY,
    player_id           NUMBER NOT NULL,
    game_id             NUMBER NOT NULL,
    carries             NUMBER,
    yards               NUMBER,
    touchdowns          NUMBER,
    avg_time_to_line    NUMBER(5,2),
    efficiency          NUMBER(5,2),
    expected_yards      NUMBER,
    season              NUMBER,
    week                NUMBER,
    CONSTRAINT fk_rush_player FOREIGN KEY (player_id) REFERENCES players(player_id),
    CONSTRAINT fk_rush_game FOREIGN KEY (game_id) REFERENCES games(game_id)
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
    weekly_id           NUMBER PRIMARY KEY,
    game_id             NUMBER NOT NULL,
    team                VARCHAR2(10) NOT NULL,
    season              NUMBER,
    week                NUMBER,
    total_yards         NUMBER,
    pass_yards          NUMBER,
    rush_yards          NUMBER,
    turnovers           NUMBER,
    penalties           NUMBER,
    possession_time     VARCHAR2(10),
    points_scored       NUMBER,
    points_allowed      NUMBER,
    date_pulled         TIMESTAMP,
    CONSTRAINT fk_weekly_game FOREIGN KEY (game_id) REFERENCES games(game_id)
);

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

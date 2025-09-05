import pandas as pd
import plotly.graph_objects as go
import nfl_data_py as nfl

def get_seasonal_data(year):
    year_list = []
    year_list.append(int(year))
    df = nfl.import_seasonal_data(year_list)
    id_df = nfl.import_ids()
    id_df = id_df[['gsis_id','name']]
    df = pd.merge(df,  
                     id_df,  
                     left_on = 'player_id',
                     right_on = 'gsis_id',
                     how ='left')
    cols = df.columns.tolist()
    cols = cols[-1:] + cols[:-2]
    df = df[cols]
    df = df.sort_values('name')

    return df

def get_weekly_data(year):
    year_list = []
    year_list.append(int(year))
    df = nfl.import_weekly_data(year_list)

    return df

def get_play_by_play_data(year):
    year_list = []
    year_list.append(int(year))
    df = nfl.import_pbp_data(year_list)

    return df

def get_weekly_roster_data(year):
    year_list = []
    year_list.append(int(year))
    df = nfl.import_weekly_rosters(year_list)

    return df

def get_ngs_data(stat_type, year):
    year_list = []
    year_list.append(int(year))
    df = nfl.import_ngs_data(stat_type, year_list)

    return df

def get_ftn_data(year):
    year_list = []
    year_list.append(int(year))
    df = nfl.import_ftn_data(year_list)

    return df

if __name__ == "__main__":
    # I want to get all teams and players for years 2015 to 2024
    # for teams I want the team stats and team depth charts
    # for players I want the player stats
    # I want to export all data into separate csv files
    # for instance team_stats_2015.xlsx, team_depth_charts_2015.xlsx, player_stats_2015.xlsx
    
     # create table inserts for players
    # with open(f"data/players.sql", "w") as f:
    #     players = nfl.import_players()
    #     for index, row in players.iterrows():
    #         player_id = index
    #         gsis_id = row['gsis_id'] if pd.notna(row['gsis_id']) else 'NULL'
    #         full_name = row['display_name'].replace("'", "''") if pd.notna(row['display_name']) else 'NULL'
    #         first_name = row['first_name'].replace("'", "''") if pd.notna(row['first_name']) else 'NULL'
    #         last_name = row['last_name'].replace("'", "''") if pd.notna(row['last_name']) else 'NULL'
    #         position = row['position'] if pd.notna(row['position']) else 'NULL'
    #         team = row['latest_team'] if pd.notna(row['latest_team']) else 'NULL'
            
    #         sql = f"INSERT INTO players (player_id, gsis_id, full_name, first_name, last_name, position, team) VALUES ({player_id}, '{gsis_id}', '{full_name}', '{first_name}', '{last_name}', '{position}', '{team}');\n"
    #         f.write(sql)
    
#     CREATE TABLE teams (
#     team_id             NUMBER PRIMARY KEY,
#     team_abbr           VARCHAR2(10) UNIQUE NOT NULL,
#     team_name           VARCHAR2(100),
#     team_nick           VARCHAR2(50),
#     team_conf           VARCHAR2(10),   -- AFC / NFC
#     team_division       VARCHAR2(20),   -- e.g. NFC West
#     team_color          VARCHAR2(10),
#     team_color2         VARCHAR2(10),
#     team_color3         VARCHAR2(10),
#     team_color4         VARCHAR2(10),
#     team_logo_wikipedia VARCHAR2(500),
#     team_logo_espn      VARCHAR2(500),
#     team_wordmark       VARCHAR2(500),
#     team_conference_logo VARCHAR2(500),
#     team_league_logo    VARCHAR2(500),
#     team_logo_squared   VARCHAR2(500)
# );
    # create table inserts for teams
    # with open(f"data/teams.sql", "w") as f:
    #     teams = nfl.import_team_desc()
    #     for index, row in teams.iterrows():
    #         team_id = index
    #         team_abbr = row['team_abbr'] if pd.notna(row['team_abbr']) else 'NULL'
    #         team_name = row['team_name'].replace("'", "''") if pd.notna(row['team_name']) else 'NULL'
    #         team_nick = row['team_nick'].replace("'", "''") if pd.notna(row['team_nick']) else 'NULL'
    #         team_conf = row['team_conf'] if pd.notna(row['team_conf']) else 'NULL'
    #         team_division = row['team_division'] if pd.notna(row['team_division']) else 'NULL'
    #         team_color = row['team_color'] if pd.notna(row['team_color']) else 'NULL'
    #         team_color2 = row['team_color2'] if pd.notna(row['team_color2']) else 'NULL'
    #         team_color3 = row['team_color3'] if pd.notna(row['team_color3']) else 'NULL'
    #         team_color4 = row['team_color4'] if pd.notna(row['team_color4']) else 'NULL'
    #         team_logo_wikipedia = row['team_logo_wikipedia'] if pd.notna(row['team_logo_wikipedia']) else 'NULL'
    #         team_logo_espn = row['team_logo_espn'] if pd.notna(row['team_logo_espn']) else 'NULL'
    #         team_wordmark = row['team_wordmark'] if pd.notna(row['team_wordmark']) else 'NULL'
    #         team_conference_logo = row['team_conference_logo'] if pd.notna(row['team_conference_logo']) else 'NULL'
    #         team_league_logo = row['team_league_logo'] if pd.notna(row['team_league_logo']) else 'NULL'
    #         team_logo_squared = row['team_logo_squared'] if pd.notna(row['team_logo_squared']) else 'NULL'
            
    #         sql = f"INSERT INTO teams (team_id, team_abbr, team_name, team_nick, team_conf, team_division, team_color, team_color2, team_color3, team_color4, team_logo_wikipedia, team_logo_espn, team_wordmark, team_conference_logo, team_league_logo, team_logo_squared) VALUES ({team_id}, '{team_abbr}', '{team_name}', '{team_nick}', '{team_conf}', '{team_division}', '{team_color}', '{team_color2}', '{team_color3}', '{team_color4}', '{team_logo_wikipedia}', '{team_logo_espn}', '{team_wordmark}', '{team_conference_logo}', '{team_league_logo}', '{team_logo_squared}');\n"
    #         f.write(sql)
    



    
    for year in range(2015, 2025):

#         CREATE TABLE schedule (
#     game_id             VARCHAR2(50) PRIMARY KEY,
#     season              NUMBER NOT NULL,
#     game_type           VARCHAR2(10),   -- REG, POST, PRE
#     week                NUMBER,
#     gameday             DATE,
#     weekday             VARCHAR2(20),
#     gametime            VARCHAR2(10),
    
#     away_team           VARCHAR2(10) NOT NULL,
#     away_score          NUMBER,
#     home_team           VARCHAR2(10) NOT NULL,
#     home_score          NUMBER,
    
#     location            VARCHAR2(50),  -- Home / Away / Neutral
#     result              VARCHAR2(10),  -- Win/Loss/Draw
#     total               NUMBER,        -- Combined points
#     overtime            NUMBER,        -- 0/1
    
#     old_game_id         VARCHAR2(50),
#     gsis                VARCHAR2(50),
#     nfl_detail_id       VARCHAR2(50),
#     pfr                 VARCHAR2(50),
#     pff                 VARCHAR2(50),
#     espn                VARCHAR2(50),
#     ftn                 VARCHAR2(50),
    
#     away_rest           NUMBER,
#     home_rest           NUMBER,
    
#     away_moneyline      NUMBER,
#     home_moneyline      NUMBER,
#     spread_line         NUMBER,
#     away_spread_odds    NUMBER,
#     home_spread_odds    NUMBER,
#     total_line          NUMBER,
#     under_odds          NUMBER,
#     over_odds           NUMBER,
    
#     div_game            NUMBER,  -- 0/1
#     roof                VARCHAR2(20),
#     surface             VARCHAR2(50),
#     temp                NUMBER,
#     wind                NUMBER,
    
#     away_qb_id          VARCHAR2(50),
#     home_qb_id          VARCHAR2(50),
#     away_qb_name        VARCHAR2(100),
#     home_qb_name        VARCHAR2(100),
#     away_coach          VARCHAR2(100),
#     home_coach          VARCHAR2(100),
#     referee             VARCHAR2(100),
#     stadium_id          VARCHAR2(50),
#     stadium             VARCHAR2(200),

#     -- Relationships
#     CONSTRAINT fk_sched_away FOREIGN KEY (away_team) REFERENCES teams(team_abbr),
#     CONSTRAINT fk_sched_home FOREIGN KEY (home_team) REFERENCES teams(team_abbr)
# );
    
        # schedule = nfl.import_schedules([year])

        # with open(f"data/schedule_{year}.sql", "w") as f:
        #     for index, row in schedule.iterrows():
        #         game_id = row['game_id'] if pd.notna(row['game_id']) else 'NULL'
        #         season = row['season'] if pd.notna(row['season']) else 'NULL'
        #         game_type = row['game_type'] if pd.notna(row['game_type']) else 'NULL'
        #         week = row['week'] if pd.notna(row['week']) else 'NULL'
        #         gameday = row['gameday'] if pd.notna(row['gameday']) else 'NULL'
        #         weekday = row['weekday'] if pd.notna(row['weekday']) else 'NULL'
        #         gametime = row['gametime'] if pd.notna(row['gametime']) else 'NULL'
                
        #         away_team = row['away_team'] if pd.notna(row['away_team']) else 'NULL'
        #         away_score = row['away_score'] if pd.notna(row['away_score']) else 'NULL'
        #         home_team = row['home_team'] if pd.notna(row['home_team']) else 'NULL'
        #         home_score = row['home_score'] if pd.notna(row['home_score']) else 'NULL'
                
        #         location = row['location'] if pd.notna(row['location']) else 'NULL'
        #         result = row['result'] if pd.notna(row['result']) else 'NULL'
        #         total = row['total'] if pd.notna(row['total']) else 'NULL'
        #         overtime = row['overtime'] if pd.notna(row['overtime']) else 'NULL'
                
        #         old_game_id = row['old_game_id'] if pd.notna(row['old_game_id']) else 'NULL'
        #         gsis = row['gsis'] if pd.notna(row['gsis']) else 'NULL'
        #         nfl_detail_id = row['nfl_detail_id'] if pd.notna(row['nfl_detail_id']) else 'NULL'
        #         pfr = row['pfr'] if pd.notna(row['pfr']) else 'NULL'
        #         pff = row['pff'] if pd.notna(row['pff']) else 'NULL'
        #         espn = row['espn'] if pd.notna(row['espn']) else 'NULL'
        #         ftn = row['ftn'] if pd.notna(row['ftn']) else 'NULL'
        #         away_rest = row['away_rest'] if pd.notna(row['away_rest']) else 'NULL'
        #         home_rest = row['home_rest'] if pd.notna(row['home_rest']) else 'NULL'
        #         away_moneyline = row['away_moneyline'] if pd.notna(row['away_moneyline']) else 'NULL'
        #         home_moneyline = row['home_moneyline'] if pd.notna(row['home_moneyline']) else 'NULL'
        #         spread_line = row['spread_line'] if pd.notna(row['spread_line']) else 'NULL'
        #         away_spread_odds = row['away_spread_odds'] if pd.notna(row['away_spread_odds']) else 'NULL'
        #         home_spread_odds = row['home_spread_odds'] if pd.notna(row['home_spread_odds']) else 'NULL'
        #         total_line = row['total_line'] if pd.notna(row['total_line']) else 'NULL'
        #         under_odds = row['under_odds'] if pd.notna(row['under_odds']) else 'NULL'
        #         over_odds = row['over_odds'] if pd.notna(row['over_odds']) else 'NULL'
        #         div_game = row['div_game'] if pd.notna(row['div_game']) else 'NULL'
        #         roof = row['roof'] if pd.notna(row['roof']) else 'NULL'
        #         surface = row['surface'] if pd.notna(row['surface']) else 'NULL'
        #         temp = row['temp'] if pd.notna(row['temp']) else 'NULL'
        #         wind = row['wind'] if pd.notna(row['wind']) else 'NULL'
        #         away_qb_id = row['away_qb_id'] if pd.notna(row['away_qb_id']) else 'NULL'
        #         home_qb_id = row['home_qb_id'] if pd.notna(row['home_qb_id']) else 'NULL'
        #         away_qb_name = row['away_qb_name'].replace("'", "''") if pd.notna(row['away_qb_name']) else 'NULL'
        #         home_qb_name = row['home_qb_name'].replace("'", "''") if pd.notna(row['home_qb_name']) else 'NULL'
        #         away_coach = row['away_coach'].replace("'", "''") if pd.notna(row['away_coach']) else 'NULL'
        #         home_coach = row['home_coach'].replace("'", "''") if pd.notna(row['home_coach']) else 'NULL'
        #         referee = row['referee'].replace("'", "''") if pd.notna(row['referee']) else 'NULL'
        #         stadium_id = row['stadium_id'] if pd.notna(row['stadium_id']) else 'NULL'
        #         stadium = row['stadium'].replace("'", "''") if pd.notna(row['stadium']) else 'NULL'

        #         sql = f"INSERT INTO schedule (game_id, season, game_type, week, gameday, weekday, gametime, away_team, away_score, home_team, home_score, location, result, total, overtime, old_game_id, gsis, nfl_detail_id, pfr, pff, espn, ftn, away_rest, home_rest, away_moneyline, home_moneyline, spread_line, away_spread_odds, home_spread_odds, total_line, under_odds, over_odds, div_game, roof, surface, temp, wind, away_qb_id, home_qb_id, away_qb_name, home_qb_name, away_coach, home_coach, referee, stadium_id, stadium) VALUES ('{game_id}', {season}, '{game_type}', {week}, TO_DATE('{gameday}', 'YYYY-MM-DD HH24:MI:SS'), '{weekday}', '{gametime}', '{away_team}', {away_score}, '{home_team}', {home_score}, '{location}', '{result}', {total}, {overtime}, '{old_game_id}', '{gsis}', '{nfl_detail_id}', '{pfr}', '{pff}', '{espn}', '{ftn}', {away_rest}, {home_rest}, {away_moneyline}, {home_moneyline}, {spread_line}, {away_spread_odds}, {home_spread_odds}, {total_line}, {under_odds}, {over_odds}, {div_game}, '{roof}', '{surface}', {temp}, {wind}, '{away_qb_id}', '{home_qb_id}', '{away_qb_name}', '{home_qb_name}', '{away_coach}', '{home_coach}', '{referee}', '{stadium_id}', '{stadium}');\n"
        #         f.write(sql)



   
    #     print(f"Getting data for year {year}")
    #     seasonal_df = get_seasonal_data(year)
    #     seasonal_df.to_excel(f"data/seasonal_data_{year}.xlsx", index=False)
    #     print(f"Data for year {year} retrieved successfully.")
        # weekly_df = get_weekly_data(year)
        # print(weekly_df.columns)

#         CREATE TABLE weekly_data (
#     player_id                VARCHAR2(20),
#     player_name              VARCHAR2(100),
#     player_display_name      VARCHAR2(100),
#     position                 VARCHAR2(10),
#     position_group           VARCHAR2(10),
#     headshot_url             VARCHAR2(500),
#     recent_team              VARCHAR2(10),
#     season                   NUMBER(4),
#     week                     NUMBER(2),
#     season_type              VARCHAR2(10),
#     opponent_team            VARCHAR2(10),
#     completions              NUMBER,
#     attempts                 NUMBER,
#     passing_yards            NUMBER,
#     passing_tds              NUMBER,
#     interceptions            NUMBER,
#     sacks                    NUMBER,
#     sack_yards               NUMBER,
#     sack_fumbles             NUMBER,
#     sack_fumbles_lost        NUMBER,
#     passing_air_yards        NUMBER,
#     passing_yards_after_catch NUMBER,
#     passing_first_downs      NUMBER,
#     passing_epa              NUMBER(9,6),
#     passing_2pt_conversions  NUMBER,
#     pacr                     NUMBER(9,6),
#     dakota                   NUMBER(9,6),
#     carries                  NUMBER,
#     rushing_yards            NUMBER,
#     rushing_tds              NUMBER,
#     rushing_fumbles          NUMBER,
#     rushing_fumbles_lost     NUMBER,
#     rushing_first_downs      NUMBER,
#     rushing_epa              NUMBER(9,6),
#     rushing_2pt_conversions  NUMBER,
#     receptions               NUMBER,
#     targets                  NUMBER,
#     receiving_yards          NUMBER,
#     receiving_tds            NUMBER,
#     receiving_fumbles        NUMBER,
#     receiving_fumbles_lost   NUMBER,
#     receiving_air_yards      NUMBER,
#     receiving_yards_after_catch NUMBER,
#     receiving_first_downs    NUMBER,
#     receiving_epa            NUMBER(9,6),
#     receiving_2pt_conversions NUMBER,
#     racr                     NUMBER(9,6),
#     target_share             NUMBER(9,6),
#     air_yards_share          NUMBER(9,6),
#     wopr                     NUMBER(9,6),
#     special_teams_tds        NUMBER,
#     fantasy_points           NUMBER(9,3),
#     fantasy_points_ppr       NUMBER(9,3),
#     CONSTRAINT weekly_data_pk PRIMARY KEY (player_id, season, week)
# );

        # with open(f"data/weekly_data_{year}.sql", "w") as f:
        #     f.write(f"set define off;\n/ \n")
        #     for index, row in weekly_df.iterrows():
        #         player_id = row['player_id'] if pd.notna(row['player_id']) else 'NULL'
        #         player_name = row['player_name'].replace("'", "''") if pd.notna(row['player_name']) else 'NULL'
        #         player_display_name = row['player_display_name'].replace("'", "''") if pd.notna(row['player_display_name']) else 'NULL'
        #         position = row['position'] if pd.notna(row['position']) else 'NULL'
        #         position_group = row['position_group'] if pd.notna(row['position_group']) else 'NULL'
        #         headshot_url = row['headshot_url'] if pd.notna(row['headshot_url']) else 'NULL'
        #         recent_team = row['recent_team'] if pd.notna(row['recent_team']) else 'NULL'
        #         season = row['season'] if pd.notna(row['season']) else 'NULL'
        #         week = row['week'] if pd.notna(row['week']) else 'NULL'
        #         season_type = row['season_type'] if pd.notna(row['season_type']) else 'NULL'
        #         opponent_team = row['opponent_team'] if pd.notna(row['opponent_team']) else 'NULL'
        #         completions = row['completions'] if pd.notna(row['completions']) else 'NULL'
        #         attempts = row['attempts'] if pd.notna(row['attempts']) else 'NULL'
        #         passing_yards = row['passing_yards'] if pd.notna(row['passing_yards']) else 'NULL'
        #         passing_tds = row['passing_tds'] if pd.notna(row['passing_tds']) else 'NULL'
        #         interceptions = row['interceptions'] if pd.notna(row['interceptions']) else 'NULL'
        #         sacks = row['sacks'] if pd.notna(row['sacks']) else 'NULL'
        #         sack_yards = row['sack_yards'] if pd.notna(row['sack_yards']) else 'NULL'
        #         sack_fumbles = row['sack_fumbles'] if pd.notna(row['sack_fumbles']) else 'NULL'
        #         sack_fumbles_lost = row['sack_fumbles_lost'] if pd.notna(row['sack_fumbles_lost']) else 'NULL'
        #         passing_air_yards = row['passing_air_yards'] if pd.notna(row['passing_air_yards']) else 'NULL'
        #         passing_yards_after_catch = row['passing_yards_after_catch'] if pd.notna(row['passing_yards_after_catch']) else 'NULL'
        #         passing_first_downs = row['passing_first_downs'] if pd.notna(row['passing_first_downs']) else 'NULL'
        #         passing_epa = row['passing_epa'] if pd.notna(row['passing_epa']) else 'NULL'
        #         passing_2pt_conversions = row['passing_2pt_conversions'] if pd.notna(row['passing_2pt_conversions']) else 'NULL'
        #         pacr = row['pacr'] if pd.notna(row['pacr']) else 'NULL'
        #         dakota = row['dakota'] if pd.notna(row['dakota']) else 'NULL'
        #         carries = row['carries'] if pd.notna(row['carries']) else 'NULL'
        #         rushing_yards = row['rushing_yards'] if pd.notna(row['rushing_yards']) else 'NULL'
        #         rushing_tds = row['rushing_tds'] if pd.notna(row['rushing_tds']) else 'NULL'
        #         rushing_fumbles = row['rushing_fumbles'] if pd.notna(row['rushing_fumbles']) else 'NULL'
        #         rushing_fumbles_lost = row['rushing_fumbles_lost'] if pd.notna(row['rushing_fumbles_lost']) else 'NULL'
        #         rushing_first_downs = row['rushing_first_downs'] if pd.notna(row['rushing_first_downs']) else 'NULL'
        #         rushing_epa = row['rushing_epa'] if pd.notna(row['rushing_epa']) else 'NULL'
        #         rushing_2pt_conversions = row['rushing_2pt_conversions'] if pd.notna(row['rushing_2pt_conversions']) else 'NULL'
        #         receptions = row['receptions'] if pd.notna(row['receptions']) else 'NULL'
        #         targets = row['targets'] if pd.notna(row['targets']) else 'NULL'
        #         receiving_yards = row['receiving_yards'] if pd.notna(row['receiving_yards']) else 'NULL'
        #         receiving_tds = row['receiving_tds'] if pd.notna(row['receiving_tds']) else 'NULL'
        #         receiving_fumbles = row['receiving_fumbles'] if pd.notna(row['receiving_fumbles']) else 'NULL'
        #         receiving_fumbles_lost = row['receiving_fumbles_lost'] if pd.notna(row['receiving_fumbles_lost']) else 'NULL'
        #         receiving_air_yards = row['receiving_air_yards'] if pd.notna(row['receiving_air_yards']) else 'NULL'
        #         receiving_yards_after_catch = row['receiving_yards_after_catch'] if pd.notna(row['receiving_yards_after_catch']) else 'NULL'
        #         receiving_first_downs = row['receiving_first_downs'] if pd.notna(row['receiving_first_downs']) else 'NULL'
        #         receiving_epa = row['receiving_epa'] if pd.notna(row['receiving_epa']) else 'NULL'
        #         receiving_2pt_conversions = row['receiving_2pt_conversions'] if pd.notna(row['receiving_2pt_conversions']) else 'NULL'
        #         racr = row['racr'] if pd.notna(row['racr']) else 'NULL'
        #         target_share = row['target_share'] if pd.notna(row['target_share']) else 'NULL'
        #         air_yards_share = row['air_yards_share'] if pd.notna(row['air_yards_share']) else 'NULL'
        #         wopr = row['wopr'] if pd.notna(row['wopr']) else 'NULL'
        #         special_teams_tds = row['special_teams_tds'] if pd.notna(row['special_teams_tds']) else 'NULL'
        #         fantasy_points = row['fantasy_points'] if pd.notna(row['fantasy_points']) else 'NULL'
        #         fantasy_points_ppr = row['fantasy_points_ppr'] if pd.notna(row['fantasy_points_ppr']) else 'NULL'
        #         sql = f"INSERT INTO weekly_data (player_id, player_name, player_display_name, position, position_group, headshot_url, recent_team, season, week, season_type, opponent_team, completions, attempts, passing_yards, passing_tds, interceptions, sacks, sack_yards, sack_fumbles, sack_fumbles_lost, passing_air_yards, passing_yards_after_catch, passing_first_downs, passing_epa, passing_2pt_conversions, pacr, dakota, carries, rushing_yards, rushing_tds, rushing_fumbles, rushing_fumbles_lost, rushing_first_downs, rushing_epa, rushing_2pt_conversions, receptions, targets, receiving_yards, receiving_tds, receiving_fumbles, receiving_fumbles_lost, receiving_air_yards, receiving_yards_after_catch, receiving_first_downs, receiving_epa, receiving_2pt_conversions, racr, target_share, air_yards_share, wopr, special_teams_tds, fantasy_points, fantasy_points_ppr) VALUES ('{player_id}', '{player_name}', '{player_display_name}', '{position}', '{position_group}', '{headshot_url}', '{recent_team}', {season}, {week}, '{season_type}', '{opponent_team}', {completions}, {attempts}, {passing_yards}, {passing_tds}, {interceptions}, {sacks}, {sack_yards}, {sack_fumbles}, {sack_fumbles_lost}, {passing_air_yards}, {passing_yards_after_catch}, {passing_first_downs}, {passing_epa}, {passing_2pt_conversions}, {pacr}, {dakota}, {carries}, {rushing_yards}, {rushing_tds}, {rushing_fumbles}, {rushing_fumbles_lost}, {rushing_first_downs}, {rushing_epa}, {rushing_2pt_conversions}, {receptions}, {targets}, {receiving_yards}, {receiving_tds}, {receiving_fumbles}, {receiving_fumbles_lost}, {receiving_air_yards}, {receiving_yards_after_catch}, {receiving_first_downs}, {receiving_epa}, {receiving_2pt_conversions}, {racr}, {target_share}, {air_yards_share}, {wopr}, {special_teams_tds}, {fantasy_points}, {fantasy_points_ppr});\n"
        #         f.write(sql)
        
        print(year)


    #     weekly_df.to_excel(f"data/weekly_data_{year}.xlsx", index=False)
    #     print(f"Weekly data for year {year} retrieved successfully.")
    #     # pbp_df = get_play_by_play_data(year)
    #     # pbp_df.to_excel(f"data/play_by_play_data_{year}.xlsx", index=False)
    #     # print(f"Play-by-play data for year {year} retrieved successfully.")
    #     weekly_roster_df = get_weekly_roster_data(year)
    #     weekly_roster_df.to_excel(f"data/weekly_roster_data_{year}.xlsx", index=False)
    #     print(f"Weekly roster data for year {year} retrieved successfully.")
        recieivng_df = get_ngs_data('receiving', year)
#         CREATE TABLE ngs_receiving (
#     receiving_id        NUMBER PRIMARY KEY,
#     player_id           NUMBER NOT NULL,
#     game_id             NUMBER NOT NULL,
#     receptions          NUMBER,
#     targets             NUMBER,
#     yards               NUMBER,
#     touchdowns          NUMBER,
#     air_yards           NUMBER,
#     yards_after_catch   NUMBER,
#     avg_separation      NUMBER(5,2),
#     catch_percent       NUMBER(5,2),
#     season              NUMBER,
#     week                NUMBER,
#     CONSTRAINT fk_recv_player FOREIGN KEY (player_id) REFERENCES players(player_id),
#     CONSTRAINT fk_recv_game FOREIGN KEY (game_id) REFERENCES games(game_id)
# );
        with open(f"data/ngs_receiving_{year}.sql", "w") as f:
            f.write(f"set define off;\n/ \n")
            for index, row in recieivng_df.iterrows():
                receiving_id = index + (year * 100000)  # to ensure unique ID across years
                player_id = row['player_gsis_id'] if pd.notna(row['player_gsis_id']) else 'NULL'
                # game_id = row['game_id'] if pd.notna(row['game_id']) else 'NULL'
                receptions = row['receptions'] if pd.notna(row['receptions']) else 'NULL'
                targets = row['targets'] if pd.notna(row['targets']) else 'NULL'
                yards = row['yards'] if pd.notna(row['yards']) else 'NULL'
                touchdowns = row['rec_touchdowns'] if pd.notna(row['rec_touchdowns']) else 'NULL'
                air_yards = row['yards'] if pd.notna(row['yards']) else 'NULL'
                yards_after_catch = row['avg_yac'] if pd.notna(row['avg_yac']) else 'NULL'
                avg_separation = row['avg_separation'] if pd.notna(row['avg_separation']) else 'NULL'
                catch_percent = row['catch_percentage'] if pd.notna(row['catch_percentage']) else 'NULL'
                season = row['season'] if pd.notna(row['season']) else 'NULL'
                week = row['week'] if pd.notna(row['week']) else 'NULL'
                # if targets != 0 and targets != 'NULL':  # only write if targets is not zero or NULL
                sql = f"INSERT INTO ngs_receiving (receiving_id, player_id, receptions, targets, yards, touchdowns, air_yards, yards_after_catch, avg_separation, catch_percent, season, week) VALUES ({receiving_id}, '{player_id}', {receptions}, {targets}, {yards}, {touchdowns}, {air_yards}, {yards_after_catch}, {avg_separation}, {catch_percent}, {season}, {week});\n"
                f.write(sql)
#     CREATE TABLE ngs_passing (
#     passing_id          NUMBER PRIMARY KEY,
#     player_id           varchar2(50) NOT NULL,
#     attempts            NUMBER,
#     completions         NUMBER,
#     yards               NUMBER,
#     touchdowns          NUMBER,
#     interceptions       NUMBER,
#     air_yards           NUMBER,
#     time_to_throw       NUMBER(5,2),
#     completion_percent  NUMBER(5,2),
#     passer_rating       NUMBER(5,2),
#     season              NUMBER,
#     week                NUMBER,
#     CONSTRAINT fk_pass_player FOREIGN KEY (player_id) REFERENCES players(player_id)
# );

    #     recieivng_df.to_excel(f"data/ngs_receiving_data_{year}.xlsx", index=False)
        passing_df = get_ngs_data('passing', year)

        with open(f"data/ngs_passing_{year}.sql", "w") as f:
            f.write(f"set define off;\n/ \n")
            for index, row in passing_df.iterrows():
                passing_id = index + (year * 100000)  # to ensure unique ID across years
                player_id = row['player_gsis_id'] if pd.notna(row['player_gsis_id']) else 'NULL'
                # player_id = row['player_gsis_id'] if pd.notna(row['player_gsis_id']) else 'NULL'
                # game_id = row['game_id'] if pd.notna(row['game_id']) else 'NULL'
                completions = row['completions'] if pd.notna(row['completions']) else 'NULL'
                attempts = row['attempts'] if pd.notna(row['attempts']) else 'NULL'
                yards = row['pass_yards'] if pd.notna(row['pass_yards']) else 'NULL'
                touchdowns = row['pass_touchdowns'] if pd.notna(row['pass_touchdowns']) else 'NULL'
                interceptions = row['interceptions'] if pd.notna(row['interceptions']) else 'NULL'
                air_yards = row['avg_completed_air_yards']  if pd.notna(row['avg_completed_air_yards']) else 'NULL'
                time_to_throw = row['avg_time_to_throw'] if pd.notna(row['avg_time_to_throw']) else 'NULL'
                completion_percent = row['completion_percentage'] if pd.notna(row['completion_percentage']) else 'NULL'
                passer_rating = row['passer_rating'] if pd.notna(row['passer_rating']) else 'NULL'
                season = row['season'] if pd.notna(row['season']) else 'NULL'
                week = row['week'] if pd.notna(row['week']) else 'NULL'
                # if attempts != 0 and attempts != 'NULL':  # only write if attempts is not zero or NULL
                sql = f"INSERT INTO ngs_passing (passing_id, player_id, completions, attempts, yards, touchdowns, interceptions, air_yards, time_to_throw, completion_percent, passer_rating, season, week) VALUES ({passing_id}, '{player_id}', {completions}, {attempts}, {yards}, {touchdowns}, {interceptions}, {air_yards}, {time_to_throw}, {completion_percent}, {passer_rating}, {season}, {week});\n"
                f.write(sql)
        #        
    #     passing_df.to_excel(f"data/ngs_passing_data_{year}.xlsx", index=False)
#     CREATE TABLE ngs_rushing (
#     rushing_id          NUMBER PRIMARY KEY,
#     player_id           NUMBER NOT NULL,
#     -- game_id             NUMBER NOT NULL,
#     carries             NUMBER,
#     yards               NUMBER,
#     touchdowns          NUMBER,
#     avg_time_to_line    NUMBER(5,2),
#     efficiency          NUMBER(5,2),
#     expected_yards      NUMBER,
#     season              NUMBER,
#     week                NUMBER,
#     CONSTRAINT fk_rush_player FOREIGN KEY (player_id) REFERENCES players(player_id),
#     -- CONSTRAINT fk_rush_game FOREIGN KEY (game_id) REFERENCES games(game_id)
# );
        rushing_df = get_ngs_data('rushing', year)

        with open(f"data/ngs_rushing_{year}.sql", "w") as f:
            f.write(f"set define off;\n/ \n")
            for index, row in rushing_df.iterrows():
                rushing_id = index + (year * 100000)  # to ensure unique ID across years
                player_id = row['player_gsis_id'] if pd.notna(row['player_gsis_id']) else 'NULL'
                # game_id = row['game_id'] if pd.notna(row['game_id']) else 'NULL'
                carries = row['rush_attempts'] if pd.notna(row['rush_attempts']) else 'NULL'
                yards = row['rush_yards'] if pd.notna(row['rush_yards']) else 'NULL'
                touchdowns = row['rush_touchdowns'] if pd.notna(row['rush_touchdowns']) else 'NULL'
                avg_time_to_line = row['avg_time_to_los'] if pd.notna(row['avg_time_to_los']) else 'NULL'
                efficiency = row['efficiency'] if pd.notna(row['efficiency']) else 'NULL'
                expected_yards = row['rush_yards_over_expected'] if pd.notna(row['rush_yards_over_expected']) else 'NULL'
                season = row['season'] if pd.notna(row['season']) else 'NULL'
                week = row['week'] if pd.notna(row['week']) else 'NULL'
                # if carries != 0 and carries != 'NULL':  # only write if carries is not zero or NULL
                sql = f"INSERT INTO ngs_rushing (rushing_id, player_id, carries, yards, touchdowns, avg_time_to_line, efficiency, expected_yards, season, week) VALUES ({rushing_id}, '{player_id}', {carries}, {yards}, {touchdowns}, {avg_time_to_line}, {efficiency}, {expected_yards}, {season}, {week});\n"
                f.write(sql)
    #     rushing_df.to_excel(f"data/ngs_rushing_data_{year}.xlsx", index=False)
    #     print(f"NGS data for year {year} saved successfully.")

    #     if year >= 2022:
    #         ftn_df = get_ftn_data(year)
    #         ftn_df.to_excel(f"data/ftn_data_{year}.xlsx", index=False)
    
    #     print(f"Data for year {year} saved successfully.")
    
        # nfl.import_pbp_data([year], downcast=True).to_excel(f"data/play_by_play_data_{year}.xlsx", index=False)

        # nfl.import_team_desc().to_excel(f"data/team_desc.xlsx", index=False)
        # nfl.import_schedules([year]).to_excel(f"data/schedules_{year}.xlsx", index=False)
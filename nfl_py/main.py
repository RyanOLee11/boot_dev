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
    for year in range(2015, 2025):
    #     print(f"Getting data for year {year}")
    #     seasonal_df = get_seasonal_data(year)
    #     seasonal_df.to_excel(f"data/seasonal_data_{year}.xlsx", index=False)
    #     print(f"Data for year {year} retrieved successfully.")
    #     weekly_df = get_weekly_data(year)
    #     weekly_df.to_excel(f"data/weekly_data_{year}.xlsx", index=False)
    #     print(f"Weekly data for year {year} retrieved successfully.")
    #     # pbp_df = get_play_by_play_data(year)
    #     # pbp_df.to_excel(f"data/play_by_play_data_{year}.xlsx", index=False)
    #     # print(f"Play-by-play data for year {year} retrieved successfully.")
    #     weekly_roster_df = get_weekly_roster_data(year)
    #     weekly_roster_df.to_excel(f"data/weekly_roster_data_{year}.xlsx", index=False)
    #     print(f"Weekly roster data for year {year} retrieved successfully.")
    #     recieivng_df = get_ngs_data('receiving', year)
    #     recieivng_df.to_excel(f"data/ngs_receiving_data_{year}.xlsx", index=False)
    #     passing_df = get_ngs_data('passing', year)
    #     passing_df.to_excel(f"data/ngs_passing_data_{year}.xlsx", index=False)
    #     rushing_df = get_ngs_data('rushing', year)
    #     rushing_df.to_excel(f"data/ngs_rushing_data_{year}.xlsx", index=False)
    #     print(f"NGS data for year {year} saved successfully.")

    #     if year >= 2022:
    #         ftn_df = get_ftn_data(year)
    #         ftn_df.to_excel(f"data/ftn_data_{year}.xlsx", index=False)
    
    #     print(f"Data for year {year} saved successfully.")
    
        nfl.import_pbp_data([year], downcast=True).to_excel(f"data/play_by_play_data_{year}.xlsx", index=False)
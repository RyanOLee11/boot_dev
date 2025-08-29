import pandas as pd


excel_file = pd.ExcelFile("UTILITY USAGE.xlsx")

for sheet_name in excel_file.sheet_names:
    print(f"Processing sheet: {sheet_name}")
    df = pd.read_excel(excel_file, sheet_name=sheet_name)

    df.to_excel(f"split_{sheet_name}.xlsx", index=False)
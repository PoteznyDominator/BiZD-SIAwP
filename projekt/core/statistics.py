
features = ['TEMPERATURE', 'APPARENTTEMPERATURE', 'HUMIDITY', 'PRECIPITATION', 'PRESSURE', 'CLOUDCOVER', 'WINDSPEED']


def base_statistics(df):
    stats = df[features]
    print(stats.describe(), end='\n\n')

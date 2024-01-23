# Skrypt służący do załadowania danych początkowych do bazy

import pandas as pd
from utils import get_connection


def populate_cities(cur):
    df = pd.read_csv('../data/cities.csv')

    print("Inserting data to the CITIES table...")
    for _, row in df.iterrows():
        cur.execute("insert into CITIES(CityID, CityName, Latitude, Longitude) values (:1, :2, :3, :4)",
                    [row['location_id'], row['name'], row['latitude'], row['longitude']])

    print("Done.")


def populate_codes(cur):
    df = pd.read_csv('../data/codes.csv', sep=';')

    print("Inserting data to the CODES table...")
    for _, row in df.iterrows():
        cur.execute("insert into Codes(CodeID, Description) values (:1, :2)",
                    [row['code'], row['description']])

    print("Done.")


def populate_weather(cur):
    df = pd.read_csv('../data/weather.csv')

    print("Inserting data to the WEATHER table...")
    for index, row in df.iterrows():
        data = dict(index=index,
                    city_id=row['location_id'],
                    code_id=row['weather_code (wmo code)'],
                    measuredate=row['time'],
                    temp=row['temperature_2m (°C)'],
                    apptemp=row['apparent_temperature (°C)'],
                    hum=row['relative_humidity_2m (%)'],
                    precip=row['precipitation (mm)'],
                    press=row['surface_pressure (hPa)'],
                    cloud=row['cloud_cover (%)'],
                    wind=row['wind_speed_10m (km/h)'])

        cur.execute(
            "INSERT INTO WEATHER (WeatherID,"
            "CityID,"
            "CodeID,"
            "MeasureDate,"
            "Temperature,"
            "ApparentTemperature,"
            "Humidity,"
            "Precipitation,"
            "Pressure,"
            "CloudCover,"
            "WindSpeed)"
            "VALUES (:1, :2, :3,  TO_TIMESTAMP(:4, 'YYYY-MM-DD\"T\"HH24:MI'), :5, :6, :7, :8, :9, :10, :11)",
            (index, data['city_id'], data['code_id'], data['measuredate'], data['temp'], data['apptemp'], data['hum'], data['precip'],
             data['press'], data['cloud'], data['wind']))

    print("Done.")


if __name__ == "__main__":
    connection = get_connection()
    cursor = connection.cursor()

    populate_cities(cursor)
    populate_codes(cursor)
    populate_weather(cursor)

    connection.commit()
    cursor.close()
    connection.close()

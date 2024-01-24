import os
from datetime import datetime
import oracledb
import csv


def add_new_weather(connection, values):
    cursor = connection.cursor()
    cursor.callproc("AddNewWeather", values)
    connection.commit()


def remove_weather(connection, index):
    cursor = connection.cursor()
    ref_cursor = connection.cursor()
    cursor.callproc('RemoveWeather', [index, ref_cursor])

    deleted_row = ref_cursor.fetchall()

    filename = os.getcwd() + '/projekt/archive/deleted-weather.csv'

    #  zapisywania do archiwum usuniętego wpisu
    with open(filename, 'a+', newline='') as f:
        fieldnames = ["WeatherID", "CityID", "CodeId", "MeasureDate", "Temperature", "ApparentTemperature", "Humidity",
                      "Precipitation", "Pressure", "CloudCover", "WindSpeed", "RemoveDate"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        needs_header = os.stat(filename).st_size == 0

        if needs_header:
            writer.writeheader()

        for row in deleted_row:
            row_dict = dict(zip(fieldnames, row))
            row_dict["RemoveDate"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            writer.writerow(row_dict)


def update_weather(connection, values):
    cursor = connection.cursor()
    cursor.callproc('UpdateWeather', values)
    connection.commit()


def test_handlers(connection):
    try:
        add_new_weather(connection, [0, 88, datetime.now(), 0.3, -0.3, 89, 0, 1000, 86, 10])
        remove_weather(connection, 8064)
        update_weather(connection, [8063, 0.3, -0.3, 89, 0, 1000, 86, 10])

    except oracledb.DatabaseError as e:
        print(f"Błąd bazy danych: {e}")

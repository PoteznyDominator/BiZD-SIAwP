import matplotlib.pyplot as plt


def visualize(df):
    df_sorted = df.sort_values(by='MEASUREDATE')

    for city_id, group in df_sorted.groupby('CITYNAME'):
        plt.figure(figsize=(12, 6))
        plt.title(f'Wizualizacja danych dla miasta  {city_id}')

        plt.subplot(2, 3, 1)
        plt.plot(group['MEASUREDATE'], group['TEMPERATURE'], label='Temperature')
        plt.xlabel('Time')
        plt.ylabel('Temperatura (°C)')
        plt.legend()

        plt.subplot(2, 3, 2)
        plt.plot(group['MEASUREDATE'], group['APPARENTTEMPERATURE'], label='Apparent Temperature')
        plt.xlabel('Time')
        plt.ylabel('Odczuwalna Temperatura (°C)')
        plt.legend()

        plt.subplot(2, 3, 3)
        plt.plot(group['MEASUREDATE'], group['HUMIDITY'], label='Humidity')
        plt.xlabel('Time')
        plt.ylabel('Wilgotność (%)')
        plt.legend()

        plt.subplot(2, 3, 4)
        plt.plot(group['MEASUREDATE'], group['PRECIPITATION'], label='Precipitation')
        plt.xlabel('Time')
        plt.ylabel('Opady (mm)')
        plt.legend()

        plt.subplot(2, 3, 5)
        plt.plot(group['MEASUREDATE'], group['PRESSURE'], label='Pressure')
        plt.xlabel('Time')
        plt.ylabel('Ciśnienie (hPa)')
        plt.legend()

        plt.subplot(2, 3, 6)
        plt.plot(group['MEASUREDATE'], group['WINDSPEED'], label='Wind Speed')
        plt.xlabel('Time')
        plt.ylabel('Prędkość wiatru (m/s)')
        plt.legend()

        plt.tight_layout()
        plt.show()

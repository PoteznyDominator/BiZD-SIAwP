from core.hypothesis import print_hypothesis
from core.statistics import base_statistics
from core.utils import get_connection, extract_df
from core.regressions import temperature_regressions, precipitation_regressions

if __name__ == '__main__':
    connection = get_connection()
    cursor = connection.cursor()

    df = extract_df(cursor, "SELECT W.*, C.CityName FROM Weather W JOIN Cities C ON W.CityID = C.CityID")

    base_statistics(df)
    print_hypothesis(df)

    # regresja przykładowa dla miasta Olsztyn
    # olsztyn = df[df['CITYNAME'] == 'Olsztyn']
    # temperature_regressions(olsztyn)
    # precipitation_regressions(olsztyn)

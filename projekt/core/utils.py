import os
import oracledb


def get_connection():
    username = os.environ.get('ORACLE_USERNAME')
    password = os.environ.get('ORACLE_PASSWORD')

    params = oracledb.ConnectParams(host='213.184.8.44', port=1521, service_name='orcl')
    return oracledb.connect(user=username, password=password, params=params)


def extract_df(cursor, command):
    cursor.execute(command)
    res = cursor.fetchall()

    df = pd.DataFrame(res)
    df.columns = [x[0] for x in cursor.description]
    return df
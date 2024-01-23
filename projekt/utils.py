import os
import oracledb


def get_connection():
    username = os.environ.get('ORACLE_USERNAME')
    password = os.environ.get('ORACLE_PASSWORD')

    params = oracledb.ConnectParams(host='213.184.8.44', port=1521, service_name='orcl')
    return oracledb.connect(user=username, password=password, params=params)


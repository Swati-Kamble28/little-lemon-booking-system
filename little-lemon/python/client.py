"""Connect and call stored procedures. Credentials come from .env/environment."""
import argparse
import os
from pathlib import Path
import mysql.connector
from dotenv import load_dotenv
load_dotenv(Path(__file__).resolve().parents[1] / '.env')

def connect():
    return mysql.connector.connect(host=os.getenv('DB_HOST','127.0.0.1'),
        port=int(os.getenv('DB_PORT','3306')),user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],database=os.getenv('DB_NAME','LittleLemonDB'),
        autocommit=True)

def call(connection, name, args=()):
    with connection.cursor() as cursor:
        cursor.callproc(name,args)
        return [result.fetchall() for result in cursor.stored_results()]

if __name__ == '__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('procedure',choices=['GetMaxQuantity','ManageBooking','AddBooking','UpdateBooking','CancelBooking'])
    parser.add_argument('parameters',nargs='*')
    args=parser.parse_args()
    with connect() as connection:
        print(call(connection,args.procedure,tuple(args.parameters)))

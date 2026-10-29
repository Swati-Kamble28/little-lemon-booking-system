"""Run only against a disposable database loaded with the supplied seed."""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'python'))
from client import connect, call
import mysql.connector

def must_fail(db,name,args):
    try: call(db,name,args)
    except mysql.connector.Error: return
    raise AssertionError(f'{name} unexpectedly succeeded')

with connect() as db:
    with db.cursor() as c:
        c.execute('SELECT COUNT(*) FROM Bookings WHERE BookingID IN (9001,9002)')
        assert c.fetchone()[0]==0, 'Test IDs already in use; use a fresh test database'
    try:
        assert call(db,'GetMaxQuantity')[0][0][0]==6
        assert 'available' in call(db,'ManageBooking',('2030-01-01',5))[0][0][0]
        call(db,'AddBooking',(9001,1,5,'2030-01-01'))
        assert 'already booked' in call(db,'ManageBooking',('2030-01-01',5))[0][0][0]
        must_fail(db,'AddBooking',(9002,2,5,'2030-01-01'))
        must_fail(db,'AddBooking',(9002,999999,4,'2030-01-01'))
        call(db,'AddBooking',(9002,2,5,'2030-01-02'))
        must_fail(db,'UpdateBooking',(9001,'2030-01-02'))
        with db.cursor() as c:
            c.execute('SELECT CAST(BookingDate AS CHAR) FROM Bookings WHERE BookingID=9001')
            assert c.fetchone()[0]=='2030-01-01', 'Conflict must preserve original booking'
        call(db,'UpdateBooking',(9001,'2030-01-03'))
        call(db,'UpdateBooking',(9001,'2030-01-03'))
        must_fail(db,'UpdateBooking',(999999,'2030-01-04'))
        call(db,'CancelBooking',(9001,))
        must_fail(db,'CancelBooking',(9001,))
        assert 'available' in call(db,'ManageBooking',('2030-01-03',5))[0][0][0]
        print('PASS: quantity, availability, add, duplicate, FK, update, rollback, cancel')
    finally:
        with db.cursor() as c:
            c.execute('DELETE FROM Bookings WHERE BookingID IN (9001,9002)')

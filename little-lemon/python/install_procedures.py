"""Create/recreate all five procedures through the Python MySQL client."""
from pathlib import Path
from client import connect
sql=(Path(__file__).resolve().parents[1]/'sql/02_procedures.sql').read_text()
body=sql.split('DELIMITER $$',1)[1].rsplit('DELIMITER ;',1)[0]
with connect() as connection:
    with connection.cursor() as cursor:
        for statement in body.split('$$'):
            if statement.strip(): cursor.execute(statement.strip())
print('Installed all five stored procedures.')

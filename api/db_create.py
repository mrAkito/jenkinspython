import sqlite3

def create():
    conn = sqlite3.connect("test_data.db")

    cur = conn.cursor()

    cur.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, age INTEGER)'
    )

    conn.close()
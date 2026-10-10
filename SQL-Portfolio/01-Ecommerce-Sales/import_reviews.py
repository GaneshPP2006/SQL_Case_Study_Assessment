import csv
import mysql.connector
from getpass import getpass
from datetime import datetime

CSV_FILE = r"C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\olist_order_reviews_dataset.csv"
BATCH_SIZE = 1000

password = getpass("Enter your MySQL password: ")

try:
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password=password,
        database="olist_ecommerce"
    )

    cursor = connection.cursor()

    insert_sql = """
        INSERT INTO order_reviews (
            review_id,
            order_id,
            review_score,
            review_comment_title,
            review_comment_message,
            review_creation_date,
            review_answer_timestamp
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """

    batch = []
    total = 0

    with open(CSV_FILE, "r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        for row in reader:
            score = int(row["review_score"])

            creation_date = datetime.strptime(
                row["review_creation_date"].strip(),
                "%Y-%m-%d %H:%M:%S"
            )

            answer_date = datetime.strptime(
                row["review_answer_timestamp"].strip(),
                "%Y-%m-%d %H:%M:%S"
            )

            batch.append((
                row["review_id"],
                row["order_id"],
                score,
                row["review_comment_title"] or None,
                row["review_comment_message"] or None,
                creation_date,
                answer_date
            ))

            if len(batch) >= BATCH_SIZE:
                cursor.executemany(insert_sql, batch)
                connection.commit()
                total += len(batch)
                print(f"Imported {total} reviews...")
                batch.clear()

        if batch:
            cursor.executemany(insert_sql, batch)
            connection.commit()
            total += len(batch)

    print(f"\nSUCCESS! Imported {total} reviews.")

except Exception as error:
    print("\nImport failed:", error)

finally:
    if "cursor" in locals():
        cursor.close()
    if "connection" in locals() and connection.is_connected():
        connection.close()
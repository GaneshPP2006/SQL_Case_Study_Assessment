import csv
import mysql.connector
from getpass import getpass

CSV_FILE = r"D:\SQL-Portfolio\01-Ecommerce-Sales\olist_products_dataset.csv"
BATCH_SIZE = 1000

password = getpass("Enter your MySQL password: ")

connection = None
cursor = None

try:
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password=password,
        database="olist_ecommerce"
    )
    cursor = connection.cursor()

    # Clear only the products table
    cursor.execute("TRUNCATE TABLE products")
    connection.commit()

    insert_sql = """
        INSERT INTO products (
            product_id,
            product_category_name,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    batch = []
    total = 0

    with open(CSV_FILE, "r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        for row in reader:
            values = (
                row["product_id"],
                row["product_category_name"] or None,
                int(row["product_name_lenght"]) if row["product_name_lenght"] else None,
                int(row["product_description_lenght"]) if row["product_description_lenght"] else None,
                int(row["product_photos_qty"]) if row["product_photos_qty"] else None,
                int(row["product_weight_g"]) if row["product_weight_g"] else None,
                int(row["product_length_cm"]) if row["product_length_cm"] else None,
                int(row["product_height_cm"]) if row["product_height_cm"] else None,
                int(row["product_width_cm"]) if row["product_width_cm"] else None
            )

            batch.append(values)

            if len(batch) >= BATCH_SIZE:
                cursor.executemany(insert_sql, batch)
                connection.commit()
                total += len(batch)
                print(f"Imported {total} products...")
                batch.clear()

        if batch:
            cursor.executemany(insert_sql, batch)
            connection.commit()
            total += len(batch)

    print(f"\nSUCCESS! Imported {total} products.")

except Exception as error:
    if connection and connection.is_connected():
        connection.rollback()
    print("\nImport failed:", error)

finally:
    if cursor:
        cursor.close()
    if connection and connection.is_connected():
        connection.close()
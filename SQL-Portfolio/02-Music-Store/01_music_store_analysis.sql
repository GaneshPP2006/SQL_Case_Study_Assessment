USE Chinook;

-- 1. Total sales and invoices
SELECT
    COUNT(DISTINCT InvoiceId) AS total_invoices,
    ROUND(SUM(Total), 2) AS total_sales
FROM Invoice;

-- 2. Sales by country
SELECT
    BillingCountry,
    COUNT(*) AS invoices,
    ROUND(SUM(Total), 2) AS total_sales
FROM Invoice
GROUP BY BillingCountry
ORDER BY total_sales DESC;

-- 3. Top 10 customers by spending
SELECT
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS customer_name,
    c.Country,
    ROUND(SUM(i.Total), 2) AS total_spent
FROM Customer c
JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Country
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Top 10 artists by sales
SELECT
    ar.ArtistId,
    ar.Name AS artist_name,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS sales_value
FROM Artist ar
JOIN Album al
    ON ar.ArtistId = al.ArtistId
JOIN Track t
    ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY ar.ArtistId, ar.Name
ORDER BY sales_value DESC
LIMIT 10;

-- 5. Top 10 best-selling tracks
SELECT
    t.TrackId,
    t.Name AS track_name,
    SUM(il.Quantity) AS units_sold,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS sales_value
FROM Track t
JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY units_sold DESC, sales_value DESC
LIMIT 10;

-- 6. Revenue by genre
SELECT
    g.Name AS genre,
    SUM(il.Quantity) AS units_sold,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS sales_value
FROM Genre g
JOIN Track t
    ON g.GenreId = t.GenreId
JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY g.GenreId, g.Name
ORDER BY sales_value DESC;

-- 7. Monthly sales
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(*) AS invoices,
    ROUND(SUM(Total), 2) AS monthly_sales
FROM Invoice
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;
# Build the real Tableau workbook
The course spreadsheet could not be retrieved here. No workbook or analysis of that file is claimed.
1. Download LittleLemon_data.xlsx from your course and place it in data/. Do not rename synthetic data to this name.
2. In Tableau Desktop, connect to Microsoft Excel and select that workbook. Inspect actual sheet and column names before using them.
3. Confirm dates, numeric sales, quantities, customer identifiers and category/cuisine fields have appropriate types. Check row grain and duplicates before aggregation.
4. Build these worksheets if supported by the actual fields: sales by customer (bar, descending), sales over time (line), sales by cuisine/category (bar), and sales versus profit (scatter, only if profit exists). Add date and category filters.
5. Build an overview dashboard containing the worksheets, with consistent currency formatting and meaningful titles. Validate totals against the input spreadsheet.
6. Save as tableau/LittleLemon.twbx using File > Save As > Tableau Packaged Workbook; include the Excel data in the package. Reopen it to verify portability.
7. For the database connection requirement, also connect via MySQL to LittleLemonDB using your local credentials and the required Tableau MySQL driver. Use TableauSales: its grain is one order line, so SUM(Sales) is valid and COUNTD(OrderID) counts orders without duplication. Save a database-sales worksheet in the same workbook; use an extract for portable review and do not embed passwords.
8. Capture real screenshots of the database connection, worksheets and dashboard in screenshots/.

Synthetic seed validation for database view only: total sales 131.00, orders 3, quantities 12. These are not findings from the course spreadsheet.

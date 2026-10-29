# Little Lemon Booking System
MySQL schema, five booking procedures and a Python client for the course peer review.

## Status: implementation package; final submission steps remain
Included: normalized schema, synthetic test records, five procedures, Python procedure installer/client, ER diagram, integration tests, Workbench/Tableau instructions.
Not included: native MySQL Workbench .mwb model, Tableau .twbx workbook, original course Excel file, actual app screenshots, or a published GitHub repository. No claim is made that these were created or that runtime tests passed.
Python files were syntax checked during preparation. MySQL, Workbench and Tableau were unavailable in the preparation environment. Run the integration tests below on MySQL before submitting.

## Design
Customers have many bookings and orders. DiningTables and Staff each have many bookings. Bookings may have many orders; orders may be unlinked to a booking. Orders and MenuItems have a many-to-many relationship through OrderItems. An order has at most one delivery record. OrderItems stores the historical unit price.
One table can be booked only once per date (course-level simplification; no time slots). UNIQUE(BookingDate,TableNumber) prevents simultaneous duplicate reservations. ManageBooking checks availability only; AddBooking performs the reservation and enforces the constraint. In a time-slot system, extend the unique key to include a slot.
GetMaxQuantity returns maximum TOTAL units per order via OrderSummary, not the maximum individual order-line quantity. Cancelling a booking retains sales history by setting Orders.BookingID to NULL. Orders.CustomerID is the purchaser; it can differ from the person reserving the table.
Procedures own their transactions where needed; call them on an autocommit connection, not within a larger caller transaction. No automated background watcher is required: Python installs and invokes the routines explicitly in response to actions.

## 1. Set up MySQL
Use MySQL 8.0.16+ (CHECK constraints enforced) with InnoDB. In Workbench, open and execute in order against a fresh database:
- sql/01_schema.sql
- sql/02_procedures.sql
- sql/03_sample_data.sql
Do not rerun schema or seed files against an existing populated database. Procedures can be reinstalled.
Use a local MySQL user with the required schema privileges; never commit a password. For a course-only local account, an administrator may grant privileges on LittleLemonDB.*. Runtime-only accounts need EXECUTE; the installer needs routine-creation privileges, and tests additionally need SELECT/DELETE.

## 2. Connect using Python
From this project directory:
```sh
python -m venv .venv
# Windows PowerShell: .venv\Scripts\Activate.ps1
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
```
Copy .env.example to .env and enter your local connection settings.
```sh
python python/install_procedures.py
python python/client.py GetMaxQuantity
python python/client.py ManageBooking 2030-01-01 5
python python/client.py AddBooking 100 1 5 2030-01-01
python python/client.py UpdateBooking 100 2030-01-02
python python/client.py CancelBooking 100
python tests/integration.py
```
Expected first result: MaxQuantityInOrder = 6. The sample AddBooking signature is (booking_id, customer_id, table_number, booking_date); UpdateBooking is (booking_id, new_date).

## 3. Create the required native Workbench model
In MySQL Workbench choose Database > Reverse Engineer, connect to your database, select LittleLemonDB, and import the tables. Arrange them in an EER diagram, ensure every FK is visible, then save the model as diagrams/LittleLemon.mwb. Export the EER diagram as PNG. The supplied ERD.png is a schema diagram, not a screenshot or native Workbench model.

## 4. Tableau
Follow tableau/BUILD_WORKBOOK.md. The original course dataset is needed to finish the requested analysis. Upload it to ChatGPT if you want further help based on its real columns and values.

## 5. GitHub and submission
Create a GitHub repository named little-lemon-booking-system. Then, in this directory:
```sh
git init
git add .
git commit -m "Add Little Lemon booking database project"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/little-lemon-booking-system.git
git push -u origin main
```
Replace YOUR_USERNAME with your actual account. Ensure .env is ignored. Review all files before pushing, including workbook connection details. Submit the actual repository URL, not this ZIP. Make it accessible to peer reviewers.

## Final review checklist
- [ ] Repository exists and all project files are visible
- [ ] Schema executed successfully in MySQL
- [ ] Python connects and installs stored procedures
- [ ] Integration tests pass; capture genuine output
- [ ] Native .mwb model and exported EER PNG included
- [ ] Course dataset analyzed and real .twbx saved/reopened
- [ ] Genuine Tableau and procedure screenshots included
- [ ] All five procedures inspected and exercised
- [ ] Review two peer projects with evidence-based feedback

Suggested peer feedback: identify the requirement, describe the observed result, reproduce a problem with concrete inputs, then suggest a correction. Do not infer correctness from screenshots alone.

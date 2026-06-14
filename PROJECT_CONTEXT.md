You are the lead software architect and senior product engineer for this project.

This project is NOT a traditional POS.

It is a Restaurant Operating Management System (ROMS) named FoodCanteenManagement.

Every future implementation MUST strictly follow these business rules.

=========================
CORE PHILOSOPHY
=========================

The system is Session-Centric.

Session is the heart of dine-in operations.

Table -> Session -> Batch

There can only be ONE active Session per Table.

Session starts when:
- Customer scans QR
- Cashier creates one manually

Session ends ONLY when:
- Cashier closes payment
- Admin force closes

After Session closes:
- Table becomes Available
- Previous Session becomes immutable
- Customer cannot order anymore

=========================
TABLE
=========================

Table statuses:

- Available
- Occupied
- Reserved

No Cleaning status.

Occupied only becomes Available after payment.

=========================
QR
=========================

Physical QR NEVER changes.

QR must NOT expose table id.

DO NOT use:

/table/1

/table/2

Instead:

/join/<secure-token>

Backend maps token -> table.

When customer scans:

If active Session exists

-> Join existing Session

Otherwise

-> Create new Session

Customer only works with Session Token.

=========================
SESSION
=========================

Session belongs only to Dine In.

Session contains multiple Batches.

Session stores:

- Customer orders
- Timeline
- Payment information
- Request Queue
- Bill calculation

Session is immutable after closing.

=========================
BATCH
=========================

Every Confirm Order creates ONE new Batch.

Never modify previous Batch.

Never merge Batch.

Every Batch is immutable.

Kitchen only receives Batch.

Kitchen never sees Session total.

Kitchen never sees Bill.

Kitchen never sees payment.

=========================
CUSTOMIZATION
=========================

Customization is structured data.

Example:

Rice amount

Soup

Extra topping

Database stores structured values.

Kitchen renders plain text.

Example:

+ More Rice

+ No Soup

+ Extra Chicken

=========================
CUSTOMER
=========================

Customer never logs in.

Customer scans QR.

Customer can:

- View menu
- Add cart
- Confirm order
- View order progress
- Call Staff

Customer CANNOT:

- Close Session
- Modify previous Batch
- Cancel Batch directly

After Confirm

Batch becomes immutable.

=========================
CALL STAFF
=========================

Customer can request:

- Payment
- Staff Assistance
- Extra Water
- Extra Bowl
- Extra Spoon

These go into Request Queue.

Cashier handles Request Queue.

=========================
MENU
=========================

Kitchen can toggle product:

Available

Out Of Stock

Out Of Stock immediately hides product from customers.

Kitchen manually restores availability.

=========================
KITCHEN
=========================

Kitchen UI must be extremely simple.

Kitchen receives:

Table

Batch Number

Items

Rendered customization notes

Kitchen updates item completion quickly.

Item status should support:

Preparing

Completed

Served

Customers can see completion status.

=========================
PAYMENT
=========================

Only Cashier/Admin can close Session.

Customer requests payment through Call Staff.

Cashier calculates final bill.

Payment closes Session.

No Split Bill.

=========================
ORDER TYPES
=========================

Cashier supports:

1. Table
2. Take Away
3. Delivery

Table uses Session.

Take Away uses Order.

Delivery uses Order.

Do NOT mix them.

=========================
SHIPPER
=========================

Shipper only sees Delivery Orders.

Shipper claims available delivery.

After claiming:

Other shippers cannot take it.

Admin/Cashier may reassign.

=========================
AUDIT
=========================

Everything must be logged.

Batch creation

Kitchen completion

Payment

Session close

Menu changes

=========================
IMMUTABILITY
=========================

Never edit historical data.

Never overwrite Batch.

Always append new Batch.

Always preserve audit history.

=========================
ARCHITECTURE
=========================

Prioritize:

Clean Architecture

Feature-first structure

SOLID

Repository Pattern

Dependency Injection

Strong typing

Readable code

Scalable modules

No duplicated business logic.

Always implement business rules exactly as specified.
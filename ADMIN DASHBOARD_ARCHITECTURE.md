# ROMS Dashboard Architecture
Version: 1.0

The Dashboard is the control center for restaurant owners.

It must answer four questions:

1. What is happening right now?
2. Is today's operation healthy?
3. How is the business performing?
4. How do I manage my restaurant?

Navigation order

Overview
Operations
Analytics
Administration
Settings

The left navigation is permanent.

Desktop:
Permanent Navigation Rail

Tablet:
Navigation Rail

Mobile:
Drawer

Never use bottom navigation.

--------------------------------

OVERVIEW

Purpose:
Understand the restaurant within 10 seconds.

Contains

• Revenue Today
• Occupied Tables
• Kitchen Load
• Customer Requests

Restaurant Health

Quick Actions

Alerts

Recent Activity

--------------------------------

OPERATIONS

Purpose:
Operate today's restaurant.

Contains

Staff Schedule

Kitchen Status

Floor Overview

Customer Requests

Live Timeline

--------------------------------

ANALYTICS

Purpose:
Business intelligence.

Contains

Revenue

Revenue Chart

Revenue Filters

Hourly Heatmap

Best Sellers

Worst Sellers

Average Order Value

Table Performance

Kitchen Performance

Payment Methods

Customer Trends

--------------------------------

ADMINISTRATION

Purpose:
Manage restaurant resources.

Contains

Staff CRUD

Staff Detail

Assign Roles

Permission Matrix

Shift Scheduler

Menu CRUD

Table CRUD

Audit Logs

--------------------------------

SETTINGS

Purpose:
Restaurant configuration.

Contains

Brand

Theme

Logo

Restaurant Images

Business Hours

Tax

Service Charge

VNPay

Printer

QR

Languages

--------------------------------

Global Rules

Dashboard pages never own business logic.

Dashboard pages consume existing UseCases.

Backend remains source of truth.

No duplicated providers.

No duplicated repositories.

No duplicated endpoints.

No fake data.

Responsive first.

Desktop priority.

Tablet optimized.

Mobile supported.

No Material Dashboard style.

Target quality:

Luxury Restaurant SaaS
2026
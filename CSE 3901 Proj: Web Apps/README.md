# Fair Share (Split the Bill)

A web application for tracking and splitting expenses among friends during group trips. 

## Feature Highlights

- Create trips with multiple participants
- Track all shared expenses
- Automatically calculates who owes whom
- Suggests minimal transfers to settle accounts
- Supports multiple currencies with automatic conversion

## Quick Start

### Prerequisites
- Ruby 3.x
- SQLite3
- Bundler

### Installation

```bash
# Clone the repository
git clone https://github.com/cse3901-2025au-1020/proj6-tbdditl.git
cd proj6-tbdditl

# Install dependencies
bundle install

# Set up the database
rails db:create
rails db:migrate
rails db:seed  # Optional: loads demo data

# Start the server
rails server

# Visit http://localhost:3000
```

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Framework** | Ruby on Rails | Full stack framework |
| **Database** | SQLite3 | Development database |
| **Authentication** | Devise | User registration & login |
| **Frontend** | Bootstrap 5 (Lux theme) | CSS Library |
| **Currency** | Money gem | Currency conversion |

## Database Schema

The application uses 5 core models:

### User
- Handles authentication (Devise)
- Stores full name and optional phone number

### Trip
- Created by an organizer
- Has start/end dates and base currency
- Contains multiple expenses

### TripMembership
- Join table for trip invitations
- Links users to trips they're invited to

### Expense
- Belongs to a trip and payer
- Has amount, description, category, and currency
- Tracks who participated

### ExpenseShare
- Keeps track of how much each user owes for a specific expense.
- Joint table for linking expenses to users with amount owed.


## Supported Currencies

The app supports 4 major currencies with manual exchange rates:
- USD (US Dollar)
- EUR (Euro)
- GBP (British Pound)
- CAD (Canadian Dollar)

All expenses are automatically converted to the trip's base currency for accurate balance calculations.

**Future Consideration:** We wish to replace the manual rates with real-time exchange rate API.

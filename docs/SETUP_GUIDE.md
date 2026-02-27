# Setup & Configuration Guide: StudioFlow

StudioFlow is built with a modern decoupled architecture: a **Vite/React** frontend and a **PHP/MySQL** backend.

## System Requirements
- **Server**: cPanel, VPS, or any shared hosting with PHP 8.0+ and MySQL 8.0+.
- **Frontend Build**: Node.js 18+ (Local machine only, for building the dist).
- **PHP Extensions**: PDO, OpenSSL, JSON, MBString.

## Installation Steps

### 1. Database Setup
- Create a new MySQL database and user.
- Import the schema from `database/schema.sql`.
- (Optional) Run `api/seeds.php` and `api/seed-admin.php` to populate sample data.

### 2. Backend Configuration
- Rename `api/.env.example` to `api/.env`.
- Update the following variables:
  ```env
  DB_HOST=localhost
  DB_NAME=your_db_name
  DB_USER=your_db_user
  DB_PASS=your_db_password
  JWT_SECRET=generate_a_long_random_string
  FRONTEND_URL=https://your-domain.com
  BACKEND_URL=https://your-domain.com/api
  ```

### 3. Frontend Deployment
- Install dependencies: `npm install`.
- Build the project: `npm run build`.
- Upload the contents of the `dist` folder to your public root (e.g., `public_html`).
- Ensure the `api` folder is placed in the same root.

## Troubleshooting
- **500 Error**: Check `api/otp_logs.txt` or server error logs.
- **CORS Issues**: Ensure `FRONTEND_URL` in `.env` matches the domain exactly.
- **Login Failures**: Verify `JWT_SECRET` is set and the database connection is active.

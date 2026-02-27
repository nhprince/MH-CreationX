## MH CreationX: Comprehensive Project Description

This document provides a detailed overview of the **MH CreationX** web application, a comprehensive project management system for a video/movie production company. It covers technical architecture, features, database schema, APIs, frontend components, security model, and deployment details to assist other AI agents or developers in understanding and contributing to the project.

---

## Project Overview

**MH CreationX** is a React-based web application designed for managing video/movie production projects, client relationships, financial tracking, and team collaboration. The system supports three user roles:

- **Admin**: Full access to all features, including user management, financial controls, and public visibility settings.
- **Team**: Restricted access for project execution, limited to their own projects/customers with no financial or public visibility controls.
- **Customer**: Read-only access to their own projects and invoices.

Key business goals:
- Streamline project lifecycle from client acquisition to delivery.
- Enable team collaboration with strict permission boundaries.
- Provide public-facing project showcases (landing page with previous works).
- Track finances, expenses, and audit trails.
- Ensure mobile-responsive design for on-the-go management.

---

## Technology Stack

### Frontend
- **Framework**: React 18 with TypeScript
- **Routing**: React Router v6
- **State Management**: Zustand (lightweight, scalable store)
- **UI Library**: Tailwind CSS + shadcn/ui components (customizable, modern design)
- **Animations**: Framer Motion
- **Icons**: Lucide React
- **Charts**: Recharts (for analytics)
- **Build Tool**: Vite (fast development and build)
- **Deployment**: Netlify (static hosting with serverless functions for APIs)

### Backend
- **Language**: PHP 8.1+
- **Framework**: Custom REST API (no full framework, procedural with OOP utilities)
- **Database**: MySQL (via PDO)
- **Authentication**: JWT (JSON Web Tokens) with custom middleware
- **Image Handling**: File uploads to server directory, URLs stored in DB
- **Email**: Custom SMTP integration for notifications (e.g., email change verification)
- **Security**: CORS middleware, input validation, prepared statements

### Development Tools
- **Version Control**: Git
- **Package Manager**: npm
- **IDE**: VS Code with Windsurf extension
- **Testing**: Manual testing (no automated tests in codebase)
- **Linting**: ESLint + Prettier for code quality

---

## Architecture Overview

### High-Level Architecture
The application follows a **client-server model** with a single-page application (SPA) frontend and a RESTful API backend.

- **Frontend**: Handles UI rendering, state management, and API calls.
- **Backend**: Processes requests, interacts with database, and serves static assets.
- **Database**: Centralized MySQL database for all persistent data.
- **File Storage**: Local server directory for images (no cloud storage like S3).

### Folder Structure
```
/home/nhprince/Workspace/MH CreationX/
├── components/          # React components (Dashboard, ProjectCard, etc.)
├── api/                 # PHP API endpoints
├── services/            # Frontend service layers (authService, projectService)
├── store.ts             # Zustand state store
├── types.ts             # TypeScript interfaces
├── utils/               # Helper functions (mapping, constants)
├── database/            # SQL migrations
├── public/              # Static assets (images, icons)
├── docs/                # Documentation (this file)
├── App.tsx              # Main app router
├── index.tsx            # React entry point
└── package.json         # Dependencies and scripts
```

### Data Flow
1. **User Action**: Triggers state update in Zustand store.
2. **API Call**: Services make HTTP requests to PHP endpoints.
3. **Backend Processing**: Validate JWT, query database, return JSON.
4. **UI Update**: Store updates, components re-render.

---

## Key Features

### Core Modules
1. **Project Management**
   - Create, read, update, delete projects.
   - Fields: Title, customer, category, description, status, price, payments, delivery date.
   - Image gallery (posters, thumbnails, YouTube covers).
   - Public visibility controls (show in previous/animation/landing).

2. **Customer Management**
   - CRUD for clients (name, contact, type).
   - Link customers to projects.
   - Restricted visibility for team members.

3. **Financial Tracking**
   - Project payments (status: Paid, Unpaid, Partial).
   - Expense logging with categories.
   - Finance hub with summaries and charts.
   - Automatic payment status recalculation.

4. **User Management**
   - Admin creates/edits users (staff: Admin/Team roles).
   - Authentication via email/password.
   - Password change, email change (admin-only).

5. **Audit Trail**
   - Log all changes (projects, customers, users, finances).
   - Filterable by user, date, action.

6. **Public Landing Page**
   - Showcase "Previous Projects" with clickable modals.
   - Slider for featured projects.
   - Responsive gallery for project images.

7. **Analytics**
   - Dashboard with project stats, financial summaries.
   - Charts for revenue, expenses, status breakdowns.

### Role-Based Permissions
- **Admin**: Full CRUD, financial controls, public settings, user management.
- **Team (Restricted)**: Create projects/customers, edit own projects (no payment/public fields), change password.
- **Customer**: View own projects, download links, invoices.

Recent hardening (2026-02-18): Implemented strict team policies to prevent unauthorized financial or visibility changes.

---

## Database Schema

**MySQL Tables** (key tables only; full schema in migrations):

1. **users**
   - `id` (CHAR(36), PRIMARY KEY)
   - `username` (VARCHAR(255)): Display name
   - `email` (VARCHAR(255)): Login identifier
   - `password` (VARCHAR(255)): Hashed
   - `role` (VARCHAR(50)): 'Admin', 'Team', etc.
   - `type` (VARCHAR(50)): 'staff' or 'customer'

2. **projects**
   - `id` (CHAR(36), PRIMARY KEY)
   - `customer_id` (CHAR(36), FOREIGN KEY to customers)
   - `created_by` (CHAR(36), FOREIGN KEY to users): For ownership tracking
   - `title`, `description`, `category`, `status`, `price`, `paid_amount`, etc.
   - Visibility flags: `is_visible_on_public`, `show_in_animation`, `show_in_previous`
   - JSON fields: `payment_details`

3. **customers**
   - `id` (CHAR(36), PRIMARY KEY)
   - `created_by` (CHAR(36), FOREIGN KEY to users): Tracks who created the customer
   - `name`, `type`, `phone`, `email`, `address`, `status`

4. **project_images**
   - `id` (CHAR(36), PRIMARY KEY)
   - `project_id` (CHAR(36), FOREIGN KEY)
   - `image_url` (VARCHAR(500)): Relative path to uploaded file
   - `type` (VARCHAR(50)): 'poster', 'thumbnail', etc.

5. **expenses**
   - `id` (CHAR(36), PRIMARY KEY)
   - `created_by` (CHAR(36), FOREIGN KEY to users)
   - `amount`, `description`, `category`, `date`

6. **audit_log**
   - `id` (CHAR(36), PRIMARY KEY)
   - `user_id` (CHAR(36), FOREIGN KEY)
   - `action` (TEXT): JSON of change details
   - `table_name`, `record_id`, `timestamp`

**Migrations**: Located in `database/migrations/`, run via phpMyAdmin or SQL client.

---

## API Endpoints

All endpoints return JSON, use JWT auth (except login), and follow REST conventions.

### Authentication
- `POST /api/auth/login.php`: Login with email/password → JWT token
- `POST /api/auth/change-password.php`: Change password (authenticated)
- `POST /api/auth/request-email-change.php`: Request email change (admin-only)
- `POST /api/auth/verify-email-change.php`: Verify email change

### Projects
- `GET /api/projects/read.php`: List projects (filtered by role)
- `POST /api/projects/create.php`: Create project (staff-only, clamps team fields)
- `PUT /api/projects/update.php`: Update project (enforces ownership for team)
- `DELETE /api/projects/delete.php`: Delete project (admin-only)

### Customers
- `GET /api/customers/read.php`: List customers (team sees own + linked)
- `POST /api/customers/create.php`: Create customer (staff-only, sets created_by)
- `PUT /api/customers/update.php`: Update customer
- `DELETE /api/customers/delete.php`: Delete customer

### Finances
- `GET /api/finance/read.php`: List expenses (team sees own)
- `POST /api/finance/create.php`: Add expense
- `DELETE /api/finance/delete.php`: Delete expense

### Users (Admin-Only)
- `GET /api/users/read.php`: List users
- `POST /api/users/create.php`: Create user
- `PUT /api/users/update.php`: Update user
- `DELETE /api/users/delete.php`: Delete user

### Audit
- `GET /api/audit/read.php`: List audit logs (team sees own actions + related)

**Common Patterns**:
- JWT in `Authorization: Bearer <token>` header
- Snake_case in DB/JSON, camelCase in frontend (mapped via `utils/mapping.ts`)
- Error responses: `{"error": "message"}` with 4xx/5xx status

---

## Frontend Components

### Core Components
- **App.tsx**: Routes with authentication guards (`StaffRoute`, `AdminRoute`)
- **Dashboard.tsx**: Main project list, filters, stats, public preview modal
- **ProjectCard.tsx**: Project display with actions (edit, delete, image preview)
- **ProjectForm.tsx**: Create/edit project form with image uploads
- **Settings.tsx**: Password/email change (email hidden for team)
- **Layout.tsx**: Navigation, sidebar, user profile
- **FinanceHub.tsx**: Expense management and summaries
- **CustomerManagement.tsx**: Customer CRUD
- **UserManagement.tsx**: Admin user management

### State Management (store.ts)
- **Slices**: projects, customers, users, expenses, auth
- **Actions**: loadInitialData, addProject, etc.
- **Selectors**: Filtered projects based on role and search

### Key Hooks/Utilities
- **useAppStore**: Access Zustand store
- **mapping.ts**: Convert DB snake_case to TS camelCase
- **constants.ts**: Enums (PaymentStatus, ProjectStatus)

---

## Security and Permissions

### Authentication
- JWT tokens with expiration
- Password hashing (bcrypt)
- Role-based routing guards

### Authorization (Role-Based Access Control)
- **Admin**: All permissions
- **Team**: CRUD own projects/customers, no financial/public flags, no delete, no user management
- **Customer**: Read-only own projects

### Recent Hardening (Feb 2026)
- Team projects default hidden (admin approval required)
- Field clamping: Team cannot set `paid_amount`, `payment_status`, `is_visible_on_public`, etc.
- Ownership enforcement: Team edits only own projects
- Customer visibility: Team sees created + linked customers

### Best Practices
- Prepared statements prevent SQL injection
- Input validation and sanitization
- CORS enabled for cross-origin requests
- Audit logging for all changes

---

## Deployment and Development

### Local Development
1. Clone repo
2. `npm install`
3. Setup MySQL DB, run migrations
4. `npm run dev` (Vite dev server)
5. PHP backend via Apache/Nginx (or `php -S` for testing)

### Build and Deploy
- `npm run build` → generates `dist/` static files
- Deploy to Netlify: Upload `dist/` + configure redirects for API routes (Netlify functions or external PHP host)
- DB: Hosted MySQL (e.g., PlanetScale or traditional hosting)

### Environment Variables
- DB credentials in `api/config/Database.php`
- JWT secret in `api/utils/JWTHandler.php`
- Email SMTP in notification endpoints

### Testing
- Manual testing: Login as different roles, test CRUD, permissions
- Browser dev tools for API calls
- Mobile testing via browser responsive mode

---

## Future Enhancements
- Automated tests (Jest for frontend, PHPUnit for backend)
- Cloud storage for images (AWS S3)
- Real-time notifications (WebSockets)
- Advanced analytics (more charts, reports)
- API versioning
- Multi-language support

This description provides a solid foundation for understanding MH CreationX. For code contributions, review the specific files mentioned and adhere to the existing patterns (e.g., TypeScript types, PHP prepared statements, Tailwind classes). If extending features, ensure role permissions are enforced and audit logs are updated.

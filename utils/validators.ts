import { Project, Customer } from '../types';

export interface ValidationResult {
    valid: boolean;
    errors: Record<string, string>;
}

export interface PasswordValidation {
    valid: boolean;
    errors: string[];
}

export const validators = {
    /**
     * Validate email format
     */
    email: (email: string): boolean => {
        if (!email) return false;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },

    /**
     * Validate phone number (Bangladesh format: 11 digits starting with 01)
     */
    phone: (phone: string): boolean => {
        if (!phone) return false;
        // Remove spaces, dashes, parentheses
        const cleaned = phone.replace(/[\s\-\(\)]/g, '');
        // Bangladesh: 01XXXXXXXXX or +8801XXXXXXXXX
        const phoneRegex = /^(\+88)?01[3-9]\d{8}$/;
        return phoneRegex.test(cleaned);
    },

    /**
     * Validate password strength
     * Requirements: min 8 chars, at least 1 uppercase, 1 lowercase, 1 number
     */
    password: (password: string): PasswordValidation => {
        const errors: string[] = [];

        if (!password || password.length < 8) {
            errors.push('Password must be at least 8 characters long');
        }
        if (!/[A-Z]/.test(password)) {
            errors.push('Password must contain at least one uppercase letter');
        }
        if (!/[a-z]/.test(password)) {
            errors.push('Password must contain at least one lowercase letter');
        }
        if (!/[0-9]/.test(password)) {
            errors.push('Password must contain at least one number');
        }

        return {
            valid: errors.length === 0,
            errors
        };
    },

    /**
     * Validate amount (must be positive number)
     */
    amount: (amount: number | string): boolean => {
        const num = typeof amount === 'string' ? parseFloat(amount) : amount;
        return !isNaN(num) && num >= 0;
    },

    /**
     * Validate date string (YYYY-MM-DD format)
     */
    date: (date: string): boolean => {
        if (!date) return false;
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(date)) return false;

        const d = new Date(date);
        return d instanceof Date && !isNaN(d.getTime());
    },

    /**
     * Validate required field (not empty)
     */
    required: (value: any): boolean => {
        if (value === null || value === undefined) return false;
        if (typeof value === 'string') return value.trim().length > 0;
        if (typeof value === 'number') return true;
        if (Array.isArray(value)) return value.length > 0;
        return !!value;
    },

    /**
     * Validate project data
     */
    projectData: (project: Partial<Project>): ValidationResult => {
        const errors: Record<string, string> = {};

        // Title validation
        if (!project.title || project.title.trim().length === 0) {
            errors.title = 'Title is required';
        } else if (project.title.length > 255) {
            errors.title = 'Title must be less than 255 characters';
        }

        // Customer validation
        if (!project.customerId) {
            errors.customerId = 'Customer is required';
        }

        // Price validation
        if (project.price !== undefined) {
            if (!validators.amount(project.price)) {
                errors.price = 'Price must be a valid positive number';
            }
        }

        // Advance validation
        if (project.advanceAmount !== undefined) {
            if (!validators.amount(project.advanceAmount)) {
                errors.advanceAmount = 'Advance must be a valid positive number';
            } else if (project.price !== undefined && project.advanceAmount > project.price) {
                errors.advanceAmount = 'Advance cannot exceed total price';
            }
        }

        // Delivery date validation
        if (project.deliveryDate) {
            if (!validators.date(project.deliveryDate)) {
                errors.deliveryDate = 'Invalid date format';
            } else {
                const deliveryDate = new Date(project.deliveryDate);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                if (deliveryDate < today) {
                    errors.deliveryDate = 'Delivery date cannot be in the past';
                }
            }
        }

        return {
            valid: Object.keys(errors).length === 0,
            errors
        };
    },

    /**
     * Validate customer data
     */
    customerData: (customer: Partial<Customer>): ValidationResult => {
        const errors: Record<string, string> = {};

        // Name validation
        if (!customer.name || customer.name.trim().length === 0) {
            errors.name = 'Name is required';
        } else if (customer.name.length > 100) {
            errors.name = 'Name must be less than 100 characters';
        }

        // Phone validation
        if (customer.phone && !validators.phone(customer.phone)) {
            errors.phone = 'Invalid phone number format (must be Bangladesh format: 01XXXXXXXXX)';
        }

        // Type validation
        if (!customer.type) {
            errors.type = 'Customer type is required';
        }

        return {
            valid: Object.keys(errors).length === 0,
            errors
        };
    }
};

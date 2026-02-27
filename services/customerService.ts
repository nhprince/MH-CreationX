import api from './api';
import { Customer } from '../types';
import { mapCustomer } from '../utils/mapping';

export const customerService = {
    // Fetch Customers with search
    async getCustomers(search = '') {
        const params = { search };
        const response = await api.get('/customers/read.php', { params });
        return mapCustomer(response.data);
    },

    // Create Customer
    async createCustomer(data: Partial<Customer>) {
        const response = await api.post('/customers/create.php', data);
        return response.data;
    },

    // Update Customer
    async updateCustomer(id: string, updates: Partial<Customer>) {
        const response = await api.post('/customers/update.php', { id, ...updates });
        return response.data;
    },

    // Delete Customer
    async deleteCustomer(id: string) {
        const response = await api.post('/customers/delete.php', { id });
        return response.data;
    }
};

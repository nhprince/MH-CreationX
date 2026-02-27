import api from './api';
import { Expense } from '../types';
import { mapExpense } from '../utils/mapping';

export const financeService = {
    // Fetch Expenses
    async getExpenses(limit = 50, offset = 0, month = '') {
        const params = { limit, offset, month };
        const response = await api.get('/finance/read.php', { params });
        return mapExpense(response.data);
    },

    // Create Expense
    async createExpense(data: Partial<Expense>) {
        const response = await api.post('/finance/create.php', data);
        return response.data;
    },

    // Delete Expense
    async deleteExpense(id: string) {
        const response = await api.post('/finance/delete.php', { id });
        return response.data;
    }
};

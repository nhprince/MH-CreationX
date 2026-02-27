import api from './api';
import { User } from '../types';

export const userService = {
    getUsers: async (): Promise<User[]> => {
        const response = await api.get('/users/read.php');
        return response.data;
    },

    createUser: async (data: { name: string; email: string; password?: string; role: 'Admin' | 'Team' }) => {
        const response = await api.post('/users/create.php', data);
        return response.data;
    },

    updateUser: async (id: string, data: Partial<User>) => {
        const response = await api.post('/users/update.php', { id, ...data });
        return response.data;
    },

    deleteUser: async (id: string) => {
        const response = await api.post('/users/delete.php', { id });
        return response.data;
    }
};

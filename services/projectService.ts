import api from './api';
import { Project } from '../types';
import { mapProject } from '../utils/mapping';

export const projectService = {
    // Fetch Projects with filters
    async getProjects(limit = 20, offset = 0, search = '', category = 'All') {
        const params = { limit, offset, search, category };
        const response = await api.get('/projects/read.php', { params });
        return mapProject(response.data);
    },



    // Create Project
    async createProject(projectData: Partial<Project>) {
        const response = await api.post('/projects/create.php', projectData);
        return response.data;
    },

    // Update Project
    async updateProject(id: string, updates: Partial<Project>) {
        // Send updates as-is (camelCase) - backend now handles conversion
        const response = await api.post('/projects/update.php', {
            id,
            ...updates
        });
        return response.data;
    },

    // Delete Project
    async deleteProject(id: string) {
        const response = await api.post('/projects/delete.php', { id });
        return response.data;
    },

    // Upload Image to Server Storage (replaces Cloudinary)
    async uploadImage(file: File) {
        // Validate file
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        if (!allowedTypes.includes(file.type)) {
            throw new Error('Invalid file type. Only images are allowed.');
        }

        // Check file size (20MB max)
        const maxSize = 20 * 1024 * 1024;
        if (file.size > maxSize) {
            throw new Error('File too large. Maximum size is 5MB.');
        }

        // Prepare FormData
        const formData = new FormData();
        formData.append('image', file);

        // Upload to server
        const response = await api.post('/uploads/upload-image.php', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });

        if (!response.data.success) {
            throw new Error(response.data.error || 'Image upload failed');
        }

        return {
            secure_url: response.data.url, // Keep this for compatibility with existing code
            url: response.data.url,
            path: response.data.path,
            filename: response.data.filename
        };
    },

    // Fetch Projects for Clients (refreshes persisted customer data)
    async getCustomerProjects() {
        const response = await api.get('/projects/read.php');
        return mapProject(response.data);
    }
};

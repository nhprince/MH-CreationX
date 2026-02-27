import api from './api';
import { AuditLog } from '../types';

export const auditService = {
    async getLogs(limit = 100, category = 'all') {
        const response = await api.get('/audit/read.php', {
            params: { limit, category }
        });
        const rows = response.data as any[];
        return (rows || []).map((r) => ({
            id: String(r.id),
            action: r.action,
            userName: r.user_name ?? r.userName ?? '',
            category: r.category,
            details: r.details,
            timestamp: r.timestamp,
            projectId: r.project_id ?? r.projectId
        })) as AuditLog[];
    }
    ,
    async getProjectLogs(projectId: string, limit = 100) {
        const response = await api.get('/audit/project.php', {
            params: { project_id: projectId, limit }
        });
        const rows = response.data as any[];
        return (rows || []).map((r) => ({
            id: String(r.id),
            action: r.action,
            userName: r.user_name ?? r.userName ?? '',
            category: r.category,
            details: r.details,
            timestamp: r.timestamp,
            projectId: r.project_id ?? r.projectId
        })) as AuditLog[];
    }
};

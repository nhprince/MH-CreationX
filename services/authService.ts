import api from './api';
import { User } from '../types';
import type {
    LoginCredentials,
    RegisterData,
    ChangePasswordData,
    ResetPasswordData,
    ForgotPasswordRequest,
    VerifyOTPRequest
} from '../types/authTypes';

export interface LoginResponse {
    token: string;
    user: User;
}

export interface OTPRequiredResponse {
    requires_otp: boolean;
    message: string;
}

export const authService = {
    async login(credentials: LoginCredentials): Promise<LoginResponse | OTPRequiredResponse> {
        // Headers are now handled by api interceptor in api.ts or added here specifically?
        // Let's add header here or assume api.ts handles it.
        // Actually, we need to modify api.ts to include fingerprint in ALL requests or just login?
        // For login we can send it in config if interceptor not yet updated.
        // But plan said modify api.ts. Let's do that later.

        // However, we can also pass it explicitly here for now or assume api.ts will be updated.
        // Let's rely on api.ts update which is in plan.
        const response = await api.post('/auth/login.php', credentials);

        if (response.data.requires_otp) {
            return response.data as OTPRequiredResponse;
        }

        if (response.data.token) {
            localStorage.setItem('mh_auth_token', response.data.token);
            localStorage.setItem('mh_user', JSON.stringify(response.data.user));
            return response.data as LoginResponse;
        }

        return response.data;
    },

    async register(userData: RegisterData) {
        const response = await api.post('/auth/register.php', userData);
        return response.data;
    },

    async forgotPassword(data: ForgotPasswordRequest) {
        const response = await api.post('/auth/forgot-password.php', data);
        return response.data;
    },

    async verifyOTP(data: VerifyOTPRequest) {
        const response = await api.post('/auth/verify-otp.php', data);
        return response.data; // Should return reset_token
    },

    async resetPassword(data: ResetPasswordData) {
        const response = await api.post('/auth/reset-password.php', data);
        return response.data;
    },

    async changePassword(data: ChangePasswordData) {
        const response = await api.post('/auth/change-password.php', data);
        return response.data;
    },

    async getProfile() {
        const response = await api.get('/auth/profile.php');
        return response.data;
    },

    logout() {
        localStorage.removeItem('mh_auth_token');
        localStorage.removeItem('mh_user');
        window.location.reload();
    },

    getCurrentUser(): User | null {
        const userStr = localStorage.getItem('mh_user');
        return userStr ? JSON.parse(userStr) : null;
    },

    isAuthenticated(): boolean {
        return !!localStorage.getItem('mh_auth_token');
    },

    getDeviceFingerprint(): string {
        const data = [
            navigator.userAgent,
            navigator.language,
            screen.width + 'x' + screen.height,
            new Date().getTimezoneOffset()
        ].join('|');
        return btoa(data).substring(0, 64);
    },

    async verifyDeviceOTP(data: VerifyOTPRequest): Promise<LoginResponse> {
        const response = await api.post('/auth/verify-device-otp.php', data);
        if (response.data.token) {
            localStorage.setItem('mh_auth_token', response.data.token);
            localStorage.setItem('mh_user', JSON.stringify(response.data.user));
        }
        return response.data;
    },

    async requestEmailChange(data: { currentPassword: string; newEmail: string }) {
        const response = await api.post('/auth/request-email-change.php', {
            current_password: data.currentPassword,
            new_email: data.newEmail
        });
        return response.data;
    },

    async verifyEmailChange(data: { newEmail: string; otp: string }) {
        const response = await api.post('/auth/verify-email-change.php', {
            new_email: data.newEmail,
            otp: data.otp
        });
        return response.data;
    }
};

// Authentication payload interfaces
export interface LoginCredentials {
    email: string;      // Changed from username to match backend API
    password: string;
}

export interface RegisterData {
    username: string;
    password: string;
    role: 'Admin' | 'Team';
}

export interface ChangePasswordData {
    currentPassword: string;
    newPassword: string;
}

export interface ResetPasswordData {
    email: string;
    password: string;
    reset_token: string;
}

export interface ForgotPasswordRequest {
    email: string;
}

export interface VerifyOTPRequest {
    email: string;
    otp: string;
}

export interface OTPRequiredResponse {
    requires_otp: boolean;
    message: string;
}

export interface EmailChangeRequest {
    currentPassword: string;
    newEmail: string;
}

export interface EmailChangeVerify {
    newEmail: string;
    otp: string;
}


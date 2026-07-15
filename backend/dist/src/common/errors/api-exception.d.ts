import { HttpException, HttpStatus } from '@nestjs/common';
export type ApiErrorBody = {
    error: {
        code: string;
        message: string;
        details?: Record<string, unknown>;
    };
};
export declare class ApiException extends HttpException {
    constructor(code: string, message: string, status: HttpStatus, details?: Record<string, unknown>);
}
export declare function unauthorized(code: string, message: string): ApiException;
export declare function forbidden(code: string, message: string): ApiException;
export declare function notFound(code: string, message: string): ApiException;
export declare function conflict(code: string, message: string): ApiException;
export declare function unprocessable(code: string, message: string): ApiException;
export declare function notImplemented(code: string, message: string): ApiException;

import { HttpException, HttpStatus } from '@nestjs/common';

export type ApiErrorBody = {
  error: {
    code: string;
    message: string;
    details?: Record<string, unknown>;
  };
};

export class ApiException extends HttpException {
  constructor(
    code: string,
    message: string,
    status: HttpStatus,
    details?: Record<string, unknown>,
  ) {
    const body: ApiErrorBody = {
      error: details ? { code, message, details } : { code, message },
    };
    super(body, status);
  }
}

export function unauthorized(code: string, message: string): ApiException {
  return new ApiException(code, message, HttpStatus.UNAUTHORIZED);
}

export function forbidden(code: string, message: string): ApiException {
  return new ApiException(code, message, HttpStatus.FORBIDDEN);
}

export function notFound(code: string, message: string): ApiException {
  return new ApiException(code, message, HttpStatus.NOT_FOUND);
}

export function conflict(code: string, message: string): ApiException {
  return new ApiException(code, message, HttpStatus.CONFLICT);
}

export function unprocessable(code: string, message: string): ApiException {
  return new ApiException(code, message, HttpStatus.UNPROCESSABLE_ENTITY);
}

export function notImplemented(code: string, message: string): ApiException {
  return new ApiException(code, message, HttpStatus.NOT_IMPLEMENTED);
}

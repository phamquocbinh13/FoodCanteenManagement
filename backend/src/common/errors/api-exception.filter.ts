import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';
import { ApiErrorBody } from './api-exception';

@Catch()
export class ApiExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();

    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const raw = exception.getResponse();

      if (typeof raw === 'object' && raw !== null && 'error' in raw) {
        res.status(status).json(raw);
        return;
      }

      const message =
        typeof raw === 'string'
          ? raw
          : typeof raw === 'object' &&
              raw !== null &&
              'message' in raw &&
              Array.isArray((raw as { message: unknown }).message)
            ? ((raw as { message: string[] }).message).join(', ')
            : typeof raw === 'object' &&
                raw !== null &&
                'message' in raw &&
                typeof (raw as { message: unknown }).message === 'string'
              ? (raw as { message: string }).message
              : exception.message;

      const body: ApiErrorBody = {
        error: {
          code: status === HttpStatus.BAD_REQUEST ? 'VALIDATION_ERROR' : 'HTTP_ERROR',
          message,
        },
      };
      res.status(status).json(body);
      return;
    }

    const body: ApiErrorBody = {
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Internal server error',
      },
    };
    res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(body);
  }
}

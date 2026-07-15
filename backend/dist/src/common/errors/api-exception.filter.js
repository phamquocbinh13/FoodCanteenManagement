"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ApiExceptionFilter = void 0;
const common_1 = require("@nestjs/common");
let ApiExceptionFilter = class ApiExceptionFilter {
    catch(exception, host) {
        const ctx = host.switchToHttp();
        const res = ctx.getResponse();
        if (exception instanceof common_1.HttpException) {
            const status = exception.getStatus();
            const raw = exception.getResponse();
            if (typeof raw === 'object' && raw !== null && 'error' in raw) {
                res.status(status).json(raw);
                return;
            }
            const message = typeof raw === 'string'
                ? raw
                : typeof raw === 'object' &&
                    raw !== null &&
                    'message' in raw &&
                    Array.isArray(raw.message)
                    ? (raw.message).join(', ')
                    : typeof raw === 'object' &&
                        raw !== null &&
                        'message' in raw &&
                        typeof raw.message === 'string'
                        ? raw.message
                        : exception.message;
            const body = {
                error: {
                    code: defaultErrorCode(status),
                    message,
                },
            };
            res.status(status).json(body);
            return;
        }
        console.error('[ApiExceptionFilter]', exception);
        const body = {
            error: {
                code: 'INTERNAL_ERROR',
                message: 'Internal server error',
            },
        };
        res.status(common_1.HttpStatus.INTERNAL_SERVER_ERROR).json(body);
    }
};
exports.ApiExceptionFilter = ApiExceptionFilter;
exports.ApiExceptionFilter = ApiExceptionFilter = __decorate([
    (0, common_1.Catch)()
], ApiExceptionFilter);
function defaultErrorCode(status) {
    switch (status) {
        case common_1.HttpStatus.BAD_REQUEST:
            return 'VALIDATION_ERROR';
        case common_1.HttpStatus.UNAUTHORIZED:
            return 'UNAUTHORIZED';
        case common_1.HttpStatus.FORBIDDEN:
            return 'FORBIDDEN';
        case common_1.HttpStatus.NOT_FOUND:
            return 'NOT_FOUND';
        case common_1.HttpStatus.CONFLICT:
            return 'CONFLICT';
        case common_1.HttpStatus.UNPROCESSABLE_ENTITY:
            return 'UNPROCESSABLE_ENTITY';
        default:
            return 'HTTP_ERROR';
    }
}
//# sourceMappingURL=api-exception.filter.js.map
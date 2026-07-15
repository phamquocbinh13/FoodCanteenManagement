"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ApiException = void 0;
exports.unauthorized = unauthorized;
exports.forbidden = forbidden;
exports.notFound = notFound;
exports.conflict = conflict;
exports.unprocessable = unprocessable;
exports.notImplemented = notImplemented;
const common_1 = require("@nestjs/common");
class ApiException extends common_1.HttpException {
    constructor(code, message, status, details) {
        const body = {
            error: details ? { code, message, details } : { code, message },
        };
        super(body, status);
    }
}
exports.ApiException = ApiException;
function unauthorized(code, message) {
    return new ApiException(code, message, common_1.HttpStatus.UNAUTHORIZED);
}
function forbidden(code, message) {
    return new ApiException(code, message, common_1.HttpStatus.FORBIDDEN);
}
function notFound(code, message) {
    return new ApiException(code, message, common_1.HttpStatus.NOT_FOUND);
}
function conflict(code, message) {
    return new ApiException(code, message, common_1.HttpStatus.CONFLICT);
}
function unprocessable(code, message) {
    return new ApiException(code, message, common_1.HttpStatus.UNPROCESSABLE_ENTITY);
}
function notImplemented(code, message) {
    return new ApiException(code, message, common_1.HttpStatus.NOT_IMPLEMENTED);
}
//# sourceMappingURL=api-exception.js.map
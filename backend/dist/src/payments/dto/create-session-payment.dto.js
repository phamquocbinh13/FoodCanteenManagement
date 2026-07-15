"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateSessionPaymentDto = exports.FORCE_CLOSE_REASONS = void 0;
const class_validator_1 = require("class-validator");
exports.FORCE_CLOSE_REASONS = [
    'customer_left',
    'dispute',
    'system_error',
    'other',
];
class CreateSessionPaymentDto {
    paymentMethod;
    closeType;
    forceCloseReason;
    forceCloseNote;
}
exports.CreateSessionPaymentDto = CreateSessionPaymentDto;
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsIn)(['cash', 'card', 'bank_transfer', 'other']),
    __metadata("design:type", String)
], CreateSessionPaymentDto.prototype, "paymentMethod", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsIn)(['payment', 'force_closed']),
    __metadata("design:type", String)
], CreateSessionPaymentDto.prototype, "closeType", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsIn)([...exports.FORCE_CLOSE_REASONS]),
    __metadata("design:type", String)
], CreateSessionPaymentDto.prototype, "forceCloseReason", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.MaxLength)(500),
    __metadata("design:type", String)
], CreateSessionPaymentDto.prototype, "forceCloseNote", void 0);
//# sourceMappingURL=create-session-payment.dto.js.map
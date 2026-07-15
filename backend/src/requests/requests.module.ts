import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { SessionsModule } from '../sessions/sessions.module';
import { RequestsCustomerController } from './requests.customer.controller';
import { RequestsStaffController } from './requests.staff.controller';
import { RequestsService } from './requests.service';

@Module({
  imports: [AuthModule, SessionsModule],
  controllers: [RequestsCustomerController, RequestsStaffController],
  providers: [RequestsService],
  exports: [RequestsService],
})
export class RequestsModule {}

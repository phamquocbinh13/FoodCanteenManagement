import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { SessionsModule } from '../sessions/sessions.module';
import { BatchesCustomerController } from './batches.customer.controller';
import { BatchesStaffController } from './batches.staff.controller';
import { BatchesService } from './batches.service';

@Module({
  imports: [AuthModule, SessionsModule],
  controllers: [BatchesCustomerController, BatchesStaffController],
  providers: [BatchesService],
  exports: [BatchesService],
})
export class BatchesModule {}

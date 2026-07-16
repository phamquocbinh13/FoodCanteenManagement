import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { SessionsModule } from '../sessions/sessions.module';
import { PaymentsController } from './payments.controller';
import { PaymentsService } from './payments.service';

import { VnpayController } from './vnpay.controller';
import { VnpayService } from './vnpay.service';

@Module({
  imports: [AuthModule, SessionsModule],
  controllers: [PaymentsController, VnpayController],
  providers: [PaymentsService, VnpayService],
})
export class PaymentsModule {}

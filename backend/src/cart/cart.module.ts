import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { SessionsModule } from '../sessions/sessions.module';
import { CartCustomerController } from './cart.customer.controller';
import { CartStaffController } from './cart.staff.controller';
import { CartService } from './cart.service';

@Module({
  imports: [AuthModule, SessionsModule],
  controllers: [CartCustomerController, CartStaffController],
  providers: [CartService],
  exports: [CartService],
})
export class CartModule {}

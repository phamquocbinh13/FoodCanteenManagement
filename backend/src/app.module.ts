import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { BatchesModule } from './batches/batches.module';
import { CartModule } from './cart/cart.module';
import { HealthModule } from './health/health.module';
import { KitchenModule } from './kitchen/kitchen.module';
import { MenuModule } from './menu/menu.module';
import { PaymentsModule } from './payments/payments.module';
import { PrismaModule } from './prisma/prisma.module';
import { RequestsModule } from './requests/requests.module';
import { RestaurantsModule } from './restaurants/restaurants.module';
import { SessionsModule } from './sessions/sessions.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '.env.example'],
    }),
    PrismaModule,
    HealthModule,
    RestaurantsModule,
    AuthModule,
    SessionsModule,
    MenuModule,
    CartModule,
    BatchesModule,
    KitchenModule,
    RequestsModule,
    PaymentsModule,
  ],
})
export class AppModule {}
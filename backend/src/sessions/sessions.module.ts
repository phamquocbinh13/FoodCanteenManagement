import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { RestaurantSessionsController } from './restaurant-sessions.controller';
import { SessionTokenGuard } from './guards/session-token.guard';
import { SessionsController } from './sessions.controller';
import { SessionsService } from './sessions.service';

@Module({
  imports: [AuthModule],
  controllers: [SessionsController, RestaurantSessionsController],
  providers: [SessionsService, SessionTokenGuard],
  exports: [SessionsService, SessionTokenGuard],
})
export class SessionsModule {}

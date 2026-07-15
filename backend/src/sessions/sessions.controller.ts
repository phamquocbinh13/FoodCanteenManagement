import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentSession } from './decorators/current-session.decorator';
import { JoinSessionDto } from './dto/sessions.dto';
import { SessionTokenGuard } from './guards/session-token.guard';
import type { CustomerSessionContext } from './guards/session-token.guard';
import { SessionsService } from './sessions.service';

@ApiTags('sessions')
@Controller('sessions')
export class SessionsController {
  constructor(private readonly sessions: SessionsService) {}

  @Post('join')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Join session by token (B2 / customer)' })
  join(@Body() dto: JoinSessionDto) {
    return this.sessions.join(dto.sessionToken, dto.deviceId);
  }

  @Get('me')
  @UseGuards(SessionTokenGuard)
  @ApiHeader({ name: 'X-Session-Token', required: false })
  @ApiOperation({
    summary: 'Validate customer session token (Bearer or X-Session-Token)',
  })
  me(@CurrentSession() ctx: CustomerSessionContext) {
    return this.sessions.me(ctx.plaintextToken);
  }
}

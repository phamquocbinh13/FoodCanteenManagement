import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { CustomerSessionContext } from '../guards/session-token.guard';

export const CurrentSession = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): CustomerSessionContext => {
    const request = ctx
      .switchToHttp()
      .getRequest<{ customerSession: CustomerSessionContext }>();
    return request.customerSession;
  },
);

import { JoinSessionDto } from './dto/sessions.dto';
import type { CustomerSessionContext } from './guards/session-token.guard';
import { SessionsService } from './sessions.service';
export declare class SessionsController {
    private readonly sessions;
    constructor(sessions: SessionsService);
    join(dto: JoinSessionDto): Promise<import("./session-snapshot.mapper").SessionSnapshot>;
    me(ctx: CustomerSessionContext): Promise<import("./session-snapshot.mapper").SessionSnapshot>;
}

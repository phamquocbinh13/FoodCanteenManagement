"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const core_1 = require("@nestjs/core");
const swagger_1 = require("@nestjs/swagger");
const app_module_1 = require("./app.module");
const api_exception_filter_1 = require("./common/errors/api-exception.filter");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    const config = app.get(config_1.ConfigService);
    const prefix = config.get('API_PREFIX', 'api/v1');
    app.setGlobalPrefix(prefix);
    app.useGlobalFilters(new api_exception_filter_1.ApiExceptionFilter());
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
    }));
    app.enableCors({
        origin: true,
        credentials: true,
    });
    const swagger = new swagger_1.DocumentBuilder()
        .setTitle('ROMS API')
        .setDescription('Restaurant Operating Management System — B0/B1/B2. ' +
        'Schema source: docs/backend/sprint-0/04_schema_mysql8.sql')
        .setVersion('0.1.0')
        .addBearerAuth()
        .build();
    swagger_1.SwaggerModule.setup('docs', app, swagger_1.SwaggerModule.createDocument(app, swagger));
    const port = config.get('PORT', 3000);
    await app.listen(port);
    console.log(`ROMS API listening on http://localhost:${port}/${prefix}`);
    console.log(`Swagger UI: http://localhost:${port}/docs`);
}
bootstrap();
//# sourceMappingURL=main.js.map
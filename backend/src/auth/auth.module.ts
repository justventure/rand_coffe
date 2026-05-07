import { Module } from '@nestjs/common'
import { JwtModule } from '@nestjs/jwt'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { PassportModule } from '@nestjs/passport'
import { AuthController } from './auth.controller'
import { AuthService } from './auth.service'
import { AtGuard, RtGuard } from './guards'
import { PrismaModule } from '../prisma/prisma.module'

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_ACCESS_SECRET'),
        signOptions: {
          expiresIn: configService.get('JWT_ACCESS_EXPIRES_IN', '15m') as any,
        },
      }),
      inject: [ConfigService],
    }),
    ConfigModule,
    PrismaModule,
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    AtGuard,
    RtGuard,
    {
      provide: 'APP_GUARD',
      useClass: AtGuard,
    },
  ],
  exports: [AuthService, JwtModule, AtGuard],
})
export class AuthModule {}

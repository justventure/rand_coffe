import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common'
import { Observable, tap, catchError, throwError } from 'rxjs'
import { PrismaService } from 'src/prisma/prisma.service'

@Injectable()
export class RequestStatInterceptor implements NestInterceptor {
  constructor(private prisma: PrismaService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest()
    const res = context.switchToHttp().getResponse()

    if (!req.url?.includes('/orders')) {
      return next.handle()
    }

    return next.handle().pipe(
      tap(() => {
        this.prisma.requestStat.create({
          data: {
            endpoint: req.route?.path ?? req.url,
            method: req.method,
            status: res.statusCode,
            success: res.statusCode < 400,
          },
        }).catch(() => {})
      }),
      catchError((err) => {
        const status = err?.status ?? 500
        this.prisma.requestStat.create({
          data: {
            endpoint: req.route?.path ?? req.url,
            method: req.method,
            status,
            success: false,
          },
        }).catch(() => {})
        return throwError(() => err)
      }),
    )
  }
}

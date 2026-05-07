import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface'

export const corsOptions: CorsOptions = {
  origin: true,
  methods: 'GET,POST,PUT,DELETE,OPTIONS',
  allowedHeaders: 'Content-Type, Authorization',
  credentials: true,
}

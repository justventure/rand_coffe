import { Controller, Get, HttpCode, HttpStatus } from '@nestjs/common'
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'
import { StatsService } from './stats.service'
import { Public } from 'src/auth/decorators'

@ApiTags('Stats')
@Controller('stats')
export class StatsController {
  constructor(private statsService: StatsService) {}

  @Public()
  @Get('requests')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get request statistics' })
  @ApiResponse({ status: 200 })
  getRequestStats() {
    return this.statsService.getRequestStats()
  }

  @Public()
  @Get('db')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get database statistics' })
  @ApiResponse({ status: 200 })
  getDbStats() {
    return this.statsService.getDbStats()
  }

  @Public()
  @Get('endpoints')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get per-endpoint request statistics' })
  @ApiResponse({ status: 200 })
  getEndpointStats() {
    return this.statsService.getEndpointStats()
  }
}

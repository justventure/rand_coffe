import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post, Put, UseGuards } from '@nestjs/common'
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'
import { OrdersService } from './orders.service'
import { CreateOrderDto, UpdateOrderStatusDto } from './dto'
import { AtGuard } from 'src/auth/guards'
import { GetCurrentUser, GetCurrentUserId } from 'src/common/decorators'
import { Public } from 'src/auth/decorators'

@ApiTags('Orders')
@ApiBearerAuth()
@UseGuards(AtGuard)
@Controller('orders')
export class OrdersController {
  constructor(private ordersService: OrdersService) {}

  @Public()
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all orders (admin)' })
  @ApiResponse({ status: 200 })
  findAll() {
    return this.ordersService.findAll()
  }

  @Public()
  @Get('my')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get current user orders' })
  @ApiResponse({ status: 200 })
  findMyOrders(@GetCurrentUserId() userId: string) {
    return this.ordersService.findByUser(userId)
  }

  @Public()
  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get order by id' })
  @ApiResponse({ status: 200 })
  @ApiResponse({ status: 404 })
  findOne(@Param('id') id: string) {
    return this.ordersService.findOne(id)
  }

  @Public()
  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create order' })
  @ApiResponse({ status: 201 })
  create(@GetCurrentUserId() userId: string, @Body() dto: CreateOrderDto) {
    return this.ordersService.create(userId, dto)
  }

  @Public()
  @Put(':id/status')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update order status' })
  @ApiResponse({ status: 200 })
  updateStatus(
    @Param('id') id: string,
    @GetCurrentUserId() userId: string,
    @GetCurrentUser('role') role: string,
    @Body() dto: UpdateOrderStatusDto,
  ) {
    return this.ordersService.updateStatus(id, userId, role, dto)
  }

  @Public()
  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete order' })
  @ApiResponse({ status: 200 })
  remove(
    @Param('id') id: string,
    @GetCurrentUserId() userId: string,
    @GetCurrentUser('role') role: string,
  ) {
    return this.ordersService.remove(id, userId, role)
  }
}

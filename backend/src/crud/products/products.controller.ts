import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post, Put, Query, UseGuards } from '@nestjs/common'
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger'
import { ProductsService } from './products.service'
import { CreateProductDto, UpdateProductDto } from './dto'
import { AtGuard } from 'src/auth/guards'
import { Public } from 'src/common/decorators'

@ApiTags('Products')
@Controller('products')
export class ProductsController {
  constructor(private productsService: ProductsService) {}

  @Public()
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all products' })
  @ApiQuery({ name: 'categoryId', required: false })
  @ApiResponse({ status: 200 })
  findAll(@Query('categoryId') categoryId?: string) {
    if (categoryId) return this.productsService.findByCategory(categoryId)
    return this.productsService.findAll()
  }

  @Public()
  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get product by id' })
  @ApiResponse({ status: 200 })
  @ApiResponse({ status: 404 })
  findOne(@Param('id') id: string) {
    return this.productsService.findOne(id)
  }

  @ApiBearerAuth()
  @UseGuards(AtGuard)
  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create product' })
  @ApiResponse({ status: 201 })
  create(@Body() dto: CreateProductDto) {
    return this.productsService.create(dto)
  }

  @ApiBearerAuth()
  @UseGuards(AtGuard)
  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update product' })
  @ApiResponse({ status: 200 })
  update(@Param('id') id: string, @Body() dto: UpdateProductDto) {
    return this.productsService.update(id, dto)
  }

  @ApiBearerAuth()
  @UseGuards(AtGuard)
  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete product' })
  @ApiResponse({ status: 200 })
  remove(@Param('id') id: string) {
    return this.productsService.remove(id)
  }
}

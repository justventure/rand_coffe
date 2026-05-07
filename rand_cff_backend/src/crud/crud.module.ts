import { Module } from '@nestjs/common'
import { PrismaModule } from 'src/prisma/prisma.module'
import { UserModule } from './user/user.module'
import { CategoriesModule } from './categories/categories.module'
import { ProductsModule } from './products/products.module'
import { OrdersModule } from './orders/orders.module'

@Module({
  imports: [PrismaModule, UserModule, CategoriesModule, ProductsModule, OrdersModule],
})
export class CrudModule {}

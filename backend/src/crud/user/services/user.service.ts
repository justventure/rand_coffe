import { Injectable, NotFoundException } from '@nestjs/common'
import { UserDto } from '../dto/user.dto'
import { PrismaService } from 'src/prisma/prisma.service'

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getAll() {
    return this.prisma.user.findMany()
  }

  async getUser(userDto: UserDto): Promise<string> {
    const user = await this.prisma.user.findUnique({
      where: { username: userDto.username },
    })

    if (!user) throw new NotFoundException('User not found')

    return JSON.stringify(user)
  }

  async validateUser(userDto: UserDto): Promise<boolean> {
    const user = await this.prisma.user.findUnique({
      where: { username: userDto.username },
    })

    return !!user
  }
}

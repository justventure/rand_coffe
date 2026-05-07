import { Controller, Get, Param } from '@nestjs/common'
import { UserService } from '../services/user.service'
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger'
import { UserDto } from '../dto/user.dto'
import { Public } from 'src/auth/decorators'
import { GetUserByUsernameDto } from '../dto/get-user-by-username.dto'

@ApiTags('Users')
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Public()
  @ApiOperation({
    summary: 'Get all users',
    description:
      'Retrieves a list of all registered users in the system. This endpoint is publicly accessible.',
  })
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved list of users',
    type: [UserDto],
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  @Get('all')
  async allUsers() {
    return await this.userService.getAll()
  }

  @Public()
  @ApiOperation({
    summary: 'Get user by username',
    description:
      'Retrieves user details by their unique username. Returns basic user information.',
  })
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved user details',
    type: UserDto,
  })
  @ApiResponse({
    status: 404,
    description: 'User not found',
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid username provided',
  })
  @Get(':username')
  async GetById(@Param() getUserByUsernameDto: GetUserByUsernameDto) {
    return await this.userService.getUser(getUserByUsernameDto)
  }
}

import { NextConfig } from 'next'
import path from 'node:path'

const root = path.resolve(__dirname, '..')
const pkg = (p: string) => path.resolve(root, 'packages', p, 'src')

const nextConfig: NextConfig = {
  reactStrictMode: true,
  output: 'standalone',
  basePath: '',
  transpilePackages: ['@refinedev/antd'],
  images: { unoptimized: true },
  turbopack: {},
  webpack: (config, { dev }) => {
    config.resolve.alias = {
      ...config.resolve.alias,
    }
    if (dev) {
      config.watchOptions = {
        poll: 1000,
        aggregateTimeout: 300,
        ignored: /node_modules\/(?!(@ui|@pages|@shared))/,
      }
    }
    return config
  },
}

export default nextConfig

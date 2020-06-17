const CompressionPlugin = require('compression-webpack-plugin')
const baseUrl = 'http://111.230.161.237:19090/'
module.exports = {
  devServer: {
    // hot: true,
    // inline: true,
    open: true,
    port: 3000,
    proxy: {
      '/process': {
        target: baseUrl
      },
      '/admin': {
        target: baseUrl
      },
      '/wecmdb': {
        target: baseUrl
      },
      '/logout': {
        target: baseUrl
      },
      '/plugin': {
        target: baseUrl
      },
      '/artifact': {
        target: baseUrl
      },
      '/batch-job': {
        target: baseUrl
      }
    }
  },
  runtimeCompiler: true,
  publicPath: '/wecmdb/',
  chainWebpack: config => {
    if (process.env.PLUGIN !== 'plugin') {
      // remove the old loader
      const img = config.module.rule('images')
      img.uses.clear()
      // add the new one
      img
        .use('file-loader')
        .loader('file-loader')
        .options({
          outputPath: 'img'
        })
    }

    config.when(process.env.PLUGIN === 'plugin', config => {
      config
        .entry('app')
        .clear()
        .add('./src/main-plugin.js') // 作为插件时
    })
    config.when(!process.env.PLUGIN, config => {
      config
        .entry('app')
        .clear()
        .add('./src/main.js') // 独立运行时
    })
  },
  productionSourceMap: process.env.PLUGIN !== 'plugin',
  configureWebpack: config => {
    if (process.env.PLUGIN === 'plugin') {
      config.optimization.splitChunks = {}
      return
    }
    if (process.env.NODE_ENV === 'production') {
      return {
        plugins: [
          new CompressionPlugin({
            algorithm: 'gzip',
            test: /\.js$|\.html$|.\css/, // 匹配文件名
            threshold: 10240, // 对超过10k的数据压缩
            deleteOriginalAssets: false // 不删除源文件
          })
        ]
      }
    }
  },
  transpileDependencies: ['detect-indent', 'redent', 'strip-indent', 'indent-string', 'crypto-random-string']
}

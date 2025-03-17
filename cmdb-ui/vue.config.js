const CompressionPlugin = require('compression-webpack-plugin')
module.exports = {
  devServer: {
    // hot: true,
    // inline: true,
    open: true,
    port: 3000,
    client: {
      overlay: false // 禁用错误覆盖层
    },
    proxy: {
      '/process': {
        target: process.env.BASE_URL
      },
      '/admin': {
        target: process.env.BASE_URL
      },
      '/wecmdb': {
        target: process.env.BASE_URL
      },
      '/logout': {
        target: process.env.BASE_URL
      },
      '/plugin': {
        target: process.env.BASE_URL
      },
      '/artifact': {
        target: process.env.BASE_URL
      },
      '/batch-job': {
        target: process.env.BASE_URL
      }
    }
  },
  runtimeCompiler: true,
  publicPath: '/wecmdb/',
  chainWebpack: config => {
    config.when(process.env.PLUGIN === 'plugin', config => {
      config.entry('app').clear().add('./src/main-plugin.js') // 作为插件时
    })
    config.when(!process.env.PLUGIN, config => {
      config.entry('app').clear().add('./src/main.js') // 独立运行时
    })
  },
  // productionSourceMap: process.env.PLUGIN === 'plugin',
  productionSourceMap: false,
  configureWebpack: config => {
    if (process.env.NODE_ENV === 'production') {
      return {
        optimization: {
          sideEffects: false
        },
        plugins: [
          new CompressionPlugin({
            algorithm: 'gzip',
            test: /\.(html|css)$/, // 匹配文件名
            threshold: 10240, // 对超过10k的数据压缩
            deleteOriginalAssets: false // 不删除源文件
          })
        ]
      }
    }
  },
  // productionSourceMap: false,
  css: {
    loaderOptions: {
      less: {
        // 启用内联 JavaScript
        javascriptEnabled: true
      }
    }
  },
  transpileDependencies: ['detect-indent', 'redent', 'strip-indent', 'indent-string', 'crypto-random-string']
}

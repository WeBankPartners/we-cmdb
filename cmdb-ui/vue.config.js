const CompressionPlugin = require('compression-webpack-plugin')
module.exports = {
  devServer: {
    // hot: true,
    // inline: true,
    open: true,
    port: 3000,
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
      config.optimization = {}
      // config.optimization = {
      //   runtimeChunk: 'single',
      //   splitChunks: {
      //     chunks: 'all',
      //     minSize: 20000, // 允许新拆出 chunk 的最小体积
      //     maxSize: 500000, // 设置chunk的最大体积为500KB
      //     automaticNameDelimiter: '-',
      //     cacheGroups: {
      //       defaultVendors: {
      //         test: /[\\/]node_modules[\\/]/,
      //         priority: -10
      //       },
      //       default: {
      //         minChunks: 2,
      //         priority: -20,
      //         reuseExistingChunk: true
      //       }
      //     }
      //   }
      // }
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

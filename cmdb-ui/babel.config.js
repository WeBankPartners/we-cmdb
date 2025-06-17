module.exports = {
  presets: [
    [
      "@vue/app", 
      { 
        useBuiltIns: 'entry',
        corejs: 3
      }
    ]
  ],
  ignore: ['src/bpmn/*']
}

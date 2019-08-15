const { override, fixBabelImports } = require("customize-cra");

module.exports = override(
  fixBabelImports("import", {
    libraryName: "@material-ui/core",
    libraryDirectory: "components",
    camel2DashComponentName: false
  })
);

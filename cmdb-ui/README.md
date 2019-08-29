# Wecube Portal

## Project setup

```
npm install
```

### Compiles and hot-reloads for development

```
npm start
```

### Compiles and minifies for production

```
npm run build
```

### Q&A

If run npm install or npm run build failed with 'node-sass' could not find a binding for your current environment error, like:

```
ERROR in Missing binding /Users/xxxxx/xxxxx/node_modules/node-sass/vendor/darwin-x64-11/binding.node
Node Sass could not find a binding for your current environment: OS X 64-bit with Node 0.10.x

```

By going into project folder and then execute:

```
npm rebuild node-sass
```

or

```
delete your node_modules and run npm install

```

Node-sass release URL: https://github.com/sass/node-sass/releases

Reference Link: https://stackoverflow.com/questions/37986800/node-sass-could-not-find-a-binding-for-your-current-environment

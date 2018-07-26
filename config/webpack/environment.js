const { environment } = require('@rails/webpacker');
const { VueLoaderPlugin } = require('vue-loader');

const customConfig = require('./custom');
const babel = require('./loaders/babel');
const vue =  require('./loaders/vue');

// Merge custom config
environment.config.merge(customConfig);

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.append('babel', babel);;
environment.loaders.append('vue', vue);
module.exports = environment;

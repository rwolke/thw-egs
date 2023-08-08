path = require "path"
webpack = require "webpack"

HtmlWebpackPlugin = require('html-webpack-plugin')

PROD = JSON.parse(process.env.PROD_ENV || '0');

plugins = []
plugins.push new webpack.ProvidePlugin
	$: "jquery"
	jquery: "jquery"
	"windows.jQuery": "jquery"
	"THREE": "THREE"
plugins.push new HtmlWebpackPlugin
	filename: "index.html"
	title: "EGS"
	template: 'src/index.hbs'
plugins.push new webpack.optimize.CommonsChunkPlugin "lib", "js/lib.js"

if PROD
	plugins.push new webpack.optimize.UglifyJsPlugin
		compress: 
			warnings: false

#plugins.push new webpack.optimize.UglifyJsPlugin

module.exports = 
#	cache: false,
#	debug:true
	devtool: 'source-map'
	entry:
		app: "app"
		lib: [
			"jquery" 
			"THREE"
			"three-orbit-controls"
			"bootstrap-webpack!bootstrap.config.js"
		]
	
	output: 
		path: path.resolve(__dirname, 'dist')
		publicPath: ""
		filename: "js/[name].js"
#		chunkFilename: "[id]_[name]_[hash].js"
	
	externals:
		google: 'google'
		App: 'app',
		window: 'window'
	
	module:
		loaders: [
			# coffescript
			{ test: /bootstrap\/js\//, loader: 'imports?jQuery=jquery' }
			{ test: /\.coffee$/, loader: "coffee-loader" }
			{ test: /\.hbs$/, loader: "handlebars-loader?inlineRequires=cmp&helperDirs[]=" + __dirname + "/src/_helpers/handlebars" }
		]
	
	resolve:
		modulesDirectories: [
			"node_modules", 
			"src",
			"src/_helpers"
		]
		extensions: ["", ".js", ".coffee", ".hbs"]
	
	resolveLoader:
		modulesDirectories: ["src/_loaders", "node_modules"]
		extensions: ["", ".webpack-loader.js", ".web-loader.js", ".loader.js", ".js"]
		packageMains: ["webpackLoader", "webLoader", "loader", "main"]
	
	plugins: plugins
	
	devServer:
		headers: 
			"Access-Control-Allow-Origin": "*"
		contentBase: "."
#		historyApiFallback: true

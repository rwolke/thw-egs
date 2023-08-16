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

if PROD
	plugins.push new webpack.optimize.UglifyJsPlugin
		compress: 
			warnings: false

#plugins.push new webpack.optimize.UglifyJsPlugin

module.exports = 
#	cache: false,
#	debug: true
	mode: if PROD then 'production' else 'development'
	devtool: 'source-map'
	entry:
		app: "app"
		lib: [
			"jquery" 
			"THREE"
			"three-orbit-controls"
		]
	
	output: 
		path: path.resolve(__dirname, 'dist')
		filename: "js/[name].js"
#		chunkFilename: "[id]_[name]_[hash].js"
	
	externals:
		google: 'google'
		App: 'app',
		window: 'window'
	
	module:
		rules: [
			{
				test: /\.(scss)$/
				use: [
					{
						loader: 'style-loader'
					}
					{
						loader: 'css-loader'
					}
					{
						loader: 'postcss-loader',
						options: {
							postcssOptions: {
								plugins: () => [
									require('autoprefixer')
								]
							}
						}
					}
					{
						loader: 'sass-loader'
					}
				]
			}
			{
				test: /\.coffee$/
				use: [
					{ loader: "coffee-loader" }
				]
			}
			{
				test: /\.hbs$/
				use: [
					{
						loader: 'handlebars-loader'
						options: {
							inlineRequires: 'assets'
							helperDirs: [__dirname + "/src/_helpers/handlebars"]
						}
					}
				]
			}
			{
				test: /\.(png|svg|jpg|jpeg|gif)$/i,
				type: 'asset/resource',
				generator: {
					filename: 'assets/[hash][ext][query]'
				}
			}
		]
	
	resolve:
		modules: [
			"node_modules", 
			"src",
			"src/_helpers"
		]
		extensions: ["", ".js", ".coffee", ".hbs"]
	
	resolveLoader:
		modules: ["src/_loaders", "node_modules"]
		extensions: ["", ".webpack-loader.js", ".web-loader.js", ".loader.js", ".js"]
		mainFields: ["webpackLoader", "webLoader", "loader", "main"]
	
	plugins: plugins
	
	devServer:
		headers: 
			"Access-Control-Allow-Origin": "*"
		static: {
			directory: path.join(__dirname, 'dist')
		}
		client: {
			overlay: {
				warnings: false,
				errors: true
			}
		}
		hot: 'only'
		compress: true
		port: 8080
#		historyApiFallback: true

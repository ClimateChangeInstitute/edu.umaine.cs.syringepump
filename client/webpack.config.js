const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  mode: "development",
  entry: {
    index: "./src/index.js",
    calibrate: "./src/calibrate.js"
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "dist")
  },
  plugins: [
    new HtmlWebpackPlugin({
      filename: "index.html",
      chunks: ["index"],
      template: "./src/index.html"
    }),
    new HtmlWebpackPlugin({
      filename: "calibrate.html",
      chunks: ["calibrate"],
      template: "./src/calibrate.html"
    }),
    new CopyWebpackPlugin({
      patterns: [
      {
        from: "src/calibrateStep.html",
        to: "calibrateStep.html",
        toType: "file"
      }
    ]})
  ],
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"]
      },
      {
        test: /\.(png|svg|jpg|gif|ico)$/,
        use: ["file-loader?name=[name].[ext]"]
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        loader: "url-loader?limit=100000"
      },
      {
        test: /bootstrap.+\.(jsx|js)$/,
        loader: "imports-loader?jQuery=jquery,$=jquery,this=>window"
      },
      {
        test: /\.html$/,
        use: [
          {
            loader: "html-loader",
            options: {
              minimize: true,
              interpolate: true
            }
          }
        ]
      }
    ]
  }
};

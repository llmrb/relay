const path = require("path")
const MiniCssExtractPlugin = require("mini-css-extract-plugin")

const root = __dirname
const production = process.env.NODE_ENV === "production"

module.exports = {
  mode: production ? "production" : "development",
  entry: path.resolve(root, "js/relay.js"),
  output: {
    path: path.resolve(root, "..", "..", "public", "js"),
    filename: "relay.js",
    clean: false,
    publicPath: "/js/"
  },
  devtool: production ? false : "source-map",
  watchOptions: {
    poll: 1000,
    aggregateTimeout: 200
  },
  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "postcss-loader",
          {
            loader: "sass-loader",
            options: {
              sassOptions: {
                silenceDeprecations: ["import"]
              }
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "../stylesheets/application.css"
    })
  ]
}

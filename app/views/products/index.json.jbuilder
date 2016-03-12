json.products @products do |product|
  json.name product.name
  json.description product.description
  json.price product.price
  json.shippingFee product.shipping_fee
end

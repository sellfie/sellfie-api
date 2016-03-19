json.products @products do |product|
  json.name product.name
  json.description product.description

  json.condition product.condition
  json.price product.price
  json.shipping_fee product.shipping_fee

  json.stock product.stock
  json.category product.category.name
  json.seller product.seller.email
end

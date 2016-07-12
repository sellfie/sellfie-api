json.id @user.id
json.email @user.email
json.username @user.username
json.name @user.name
json.gender @user.gender
json.nationality @user.nationality
[ :age, :address, :phone ].each do |optional_attr|
  next unless attr_val = @user.send(optional_attr)
  json.set! optional_attr, attr_val
end

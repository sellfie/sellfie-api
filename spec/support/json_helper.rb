module JsonHelper

  def json(obj)
    JSON.parse(obj, symbolize_names: true)
  end
end

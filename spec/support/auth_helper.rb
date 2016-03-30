module AuthHelper

  # Signs in using the credentials of the user provided
  # and returns the access_token
  def sign_in_as(user)
    post user_session_path, {
      email: user.email,
      password: user.password
    }
    response.header
  end

  def api_get(url, unfiltered_header)
    get json_url(url), filter_headers(unfiltered_header)
    response.header
  end

  def api_post(url, parameters, unfiltered_header)
    post json_url(url), parameters.to_json, filter_headers(unfiltered_header)
    response.header
  end

  private

  def json_url(url)
    "#{url}.json"
  end

  def filter_headers(header)
    header.select { |k, v| required_auth_headers.include? k }
    header['Accept'] = Mime::JSON.to_s
    header['Content-Type'] = Mime::JSON.to_s
    header
  end

  def required_auth_headers
    # filter out the headers that are required
    ['access-token', 'token-type', 'client', 'expiry', 'uid']
  end

end

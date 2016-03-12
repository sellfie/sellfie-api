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

  def api_get(path, unfiltered_header)
    get json_path(path), {}, filter_headers(unfiltered_header)
  end

  private

  def json_path(path)
    "#{path}.json"
  end

  def filter_headers(header)
    header.select { |k, v| required_auth_headers.include? k }
  end

  def required_auth_headers
    # filter out the headers that are required
    ['access-token', 'token-type', 'client', 'expiry', 'uid']
  end

end

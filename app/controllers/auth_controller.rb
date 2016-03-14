class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def auth_expa
    url = 'https://auth.aiesec.org/users/sign_in'
    agent = Mechanize.new
    page = agent.get(url)
    aiesec_form = page.form() 
    aiesec_form.field_with(:name => 'user[email]').value = "laila.khaled01@gmail.com" 
    aiesec_form.field_with(:name => 'user[password]').value = "lailakhaled" 
    page = agent.submit(aiesec_form, aiesec_form.buttons.first)
    
    if page.code.to_s == '200'
      cj = agent.cookie_jar
      if cj.jar['experience.aiesec.org'] == nil
	render json: {message: 'error'}
      else
        @expa_token = cj.jar['experience.aiesec.org']['/']["expa_token"].value
        body = create_user
	render json: body
      end
    end
  end

  def create_user
    uri = URI.parse("https://gis-api.aiesec.org/v2/people.json")
    params['access_token'] = @expa_token
    new_params = params.slice!(:auth, :controller, :action)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    req = Net::HTTP::Post.new(uri.path, new_params)
    response = http.request(req)
    response.body
  end
end

OmniAuth.config.logger = Rails.logger
require "omniauth-google-oauth2"
Rails.application.config.middleware.use OmniAuth::Builder do
provider :google_oauth2, '964198746981-mt6o9kdcjbl1m9ddg7efdtf26dvn6h08.apps.googleusercontent.com', 'ReA5L-ds_AeOGpOOePKka_eK', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end



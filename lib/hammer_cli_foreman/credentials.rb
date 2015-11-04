module HammerCLIForeman
  module Credentials

    require 'hammer_cli_foreman/credentials/certificate.rb'
    require 'hammer_cli_foreman/credentials/basic.rb'

    def self.credentials
      username = HammerCLI::Settings.get(:_params, :username) || ENV['FOREMAN_USERNAME'] || HammerCLI::Settings.get(:foreman, :username)
      password = HammerCLI::Settings.get(:_params, :password) || ENV['FOREMAN_PASSWORD'] || HammerCLI::Settings.get(:foreman, :password)
      ssl_client_cert = HammerCLI::Settings.get(:_params, :ssl_client_cert) || ENV['FOREMAN_CLIENTCERT'] || HammerCLI::Settings.get(:foreman, :ssl_client_cert)
      ssl_client_key = HammerCLI::Settings.get(:_params, :ssl_client_key) || ENV['FOREMAN_CLIENTKEY'] || HammerCLI::Settings.get(:foreman, :ssl_client_key)
      cred = nil
      if ssl_client_cert && ssl_client_key
        cred = CertificateCredentials.new(
          :ssl_client_cert => ssl_client_cert,
          :ssl_client_key  => ssl_client_key
        )
      else
        cred = BasicCredentials.new(
          :username => username,
          :password => password,
        )
      end
      cred
    end

  end
end

module HammerCLIForeman
  class CertificateCredentials < ApipieBindings::AbstractCredentials

    # Can keep client certificate and key
    # @param [Hash] params
    # @option params [String] :ssl_client_cert path to the user's client certificate
    # @option params [String] :ssl_client_key path to the private key of the user's client certificate
    # @example use container
    #   c = HammerCLIForeman::CertificateCredentials.new(:ssl_client_cert => '<path to cert>', :ssl_client_key => 'path to key>')
    #   c.username
    #   => <subject dn of client certificate>
    def initialize(params={})
      @ssl_client_cert = params[:ssl_client_cert] ? OpenSSL::X509::Certificate.new(File.read(params[:ssl_client_cert])) : nil
      @ssl_client_key = params[:ssl_client_key] ? OpenSSL::PKey::RSA.new(File.read(params[:ssl_client_key])) : nil
    end

    def login
    end

    def ssl_client_cert
      @ssl_client_cert
    end

    def ssl_client_key
      @ssl_client_key
    end

    def username
      @username ||= (@ssl_client_cert.nil? ? nil : @ssl_client_cert.subject)
    end

    def empty?
      @ssl_client_cert.nil? && @ssl_client_key.nil?
    end

    def clear
      super
      @ssl_client_cert = nil
      @ssl_client_key = nil
    end

    # Convert credentials to hash usable for merging to RestClient configuration.
    # @return [Hash]
    def to_params
      {
        :ssl_client_cert => ssl_client_cert,
        :ssl_client_key => ssl_client_key,
      }
    end

  end
end

module Api
  #
  # This class contain all the basic method for api
  #
  # @author [rohitjangid]
  #
  class ApiInterface
    BASE_URL = nil
    TIMEOUT = Settings.REST_CLIENT.TIMEOUTS.DEFAULT
    USER_AGENT = Settings.REST_CLIENT.USER_AGENT

    private

    #
    # Make get request
    #
    def get(uri, params = {})
      make_request(:get, uri, params)
    end

    #
    # Make post request
    #
    def post(uri, params)
      make_request(:post, uri, params)
    end

    #
    # Make put request
    #
    def put(uri, params)
      make_request(:put, uri, params)
    end

    #
    # Make delete request
    #
    def delete(uri, params = {})
      make_request(:delete, uri, params)
    end

    #
    # Make HTTP request
    # @param method [Symbol] Type of Request
    # @param params [Hash] Params
    #
    def make_request(method, uri, params)
      if connection_pool.present?
        request_using_connection_pool(method, uri, params)
      else
        request_using_rest_client(method, uri, params)
      end
    end

    #
    # Request using RestClient Gem
    #
    def request_using_rest_client(method, uri, params)
      url = self.class::BASE_URL + uri
      params.merge!(common_params)
      pre_request_hook # Run pre hook
      response_data = begin
                      case method
                      when :get
                        response = RestClient::Request.execute(
                                                                method: method,
                                                                url: url,
                                                                headers: headers.merge(params: params, user_agent: USER_AGENT),
                                                                timeout: self.class::TIMEOUT
                                                              )
                      else
                        response = RestClient::Request.execute(
                                                                method: method,
                                                                url: url,
                                                                payload: build_request_payload(params),
                                                                headers: headers.merge(user_agent: USER_AGENT),
                                                                timeout: self.class::TIMEOUT
                                                              )
                      end
                      success_response(response, response.code)
                    rescue => error
                      log_to_sentry(method, url, params)
                      failure_response(error, error.http_code)
                    end
      log_request(url, method, params, headers, response_data) # Log request
      response_data
    end

    #
    # Request using Connection Pool
    #
    def request_using_connection_pool(method, uri, params)
      url = self.class::BASE_URL + uri
      params.merge!(common_params)
      uri = URI(url)

      # Initialize the boundary limit for number of requests
      attempts = 0
      max_attempts = 5

      # Initiate request
      response_data
      response = connection_pool.with do |conn|
        begin
          case method
          when :get
            #####################
            #### GET REQUEST ####
            #####################
            uri.query = URI.encode_www_form(params)
            conn.connection.request(uri)
          when :post
            ######################
            #### POST REQUEST ####
            ######################
            req = Net::HTTP::Post.new(uri)
            req.set_form_data(params)
            conn.connection.request(uri, req)
          else
            not_implemented
          end
        rescue Net::HTTP::Persistent::Error => e
          # Only rescue those error with to many connection errors
          raise unless e.message =~ /too many connection resets/

          if attempts < max_attempts
            # Reset the connection and try again
            conn.reset
            attempts += 1
            retry
          else
            log_to_sentry(method, uri, params)
          end
        rescue Net::OpenTimeout => e
          if attempts < max_attempts
            # Reset the connection and try again
            conn.reset
            attempts += 1
            retry
          else
            log_to_sentry(method, uri, params)
          end
        end
      end

      # Process response
      response_data = if response.code == '200'
                        success_response(response.body, response.code)
                      else
                        failure_response(response.body, response.code)
                      end
      log_request(uri, method, params, headers, response_data)
      response_data
    end

    def common_params
      {}
    end

    #
    # Headers for the request
    #
    def headers
      {}
    end

    #
    # Parse params and build payload for request
    #
    def build_request_payload(params)
      params
    end

    #
    # Parse and prepare success response
    #
    def success_response(response, status_code)
      {
        success: true,
        status_code: status_code,
        data: success_response_data(response)
      }
    end

    #
    # Parse and prepare failure response
    #
    def failure_response(error, status_code)
      {
        success: false,
        status_code: status_code,
        message: failure_error_data(error)
      }
    end

    def success_response_data(response)
      not_implemented
    end

    def failure_error_data(error)
      not_implemented
    end

    def connection_pool
      nil
    end

    #
    # Log request to sentry
    #
    def log_to_sentry(method, uri, params)
      Sentry.error('Api Failed', method: method, uri: uri, params: params)
    end

    #
    # Pre Request Hook
    #
    def pre_request_hook
      @start_time = Time.zone.now
    end

    #
    # Log request
    #
    def log_request(uri, method, params, headers, response)
      return unless Settings.REST_CLIENT.ENABLE_LOGGING
      duration = Time.zone.now - @start_time
      RestClientLogger.log(
        uri: uri,
        method: method,
        params: params,
        headers: headers,
        response: response,
        timestamp: Time.zone.now,
        duration: duration
      )
    end
  end
end

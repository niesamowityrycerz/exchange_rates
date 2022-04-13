module ExchangeRates
  module NbpExternalService

    class ResponseHandler

      def initialize(nbp_response)
        @nbp_response = nbp_response
      end

      attr_reader :nbp_response

      def call 
        case nbp_response.status
        when 200
          { status: 'success', rate: extracted_rate(nbp_response) }
        when 404
          { status: 'failure', error: 'Missing data' }
        when 400
          { status: 'failure', error: 'Invalid request' }
        else
          { status: 'failure', error: 'Service is offline' }
        end
      end

      private

      def extracted_rate(response)
        parsed_body = JSON.parse(response.body)
        parsed_body["rates"].first["mid"]
      end

    end
  end
end
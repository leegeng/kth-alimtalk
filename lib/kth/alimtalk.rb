require "kth/alimtalk/version"

module Kth
  module Alimtalk
    class Client
      attr_accessor :client_id, :key

      BASE_URL = "http://api.apistore.co.kr".freeze
      # TODO. 코드 및 메세지 정의 맵핑 추가

      def initialize(client_id, key)
        self.client_id = client_id
        self.key = key
      end

      def send_message(phone_number, callback, msg, template_code, failed_type, options)
        request_url = "/kko/1/msg/#{client_id}"
        params = {
          'PHONE' => phone_number,
          'CALLBACK' => callback,
          'MSG' => msg,
          'TEMPLATE_CODE' => template_code,
          'FAILED_TYPE' => failed_type
        }

        if options.present?
          params['REQDATE'] = options['request_date'].strftime("%Y%m%d%H%M%S") if options['request_date']
          params['URL'] = options['url'] if options['url']
          params['URL_BUTTON_TXT'] = options['url_button_text'] if options['url_button_text']
          params['FAILED_SUBJECT'] = options['failed_subject'] if options['failed_subject']
          params['FAILED_MSG'] = options['failed_msg']
        end

        send_post_request request_url, params
      end

      def report(cmid)
        request_url = "/kko/1/report/#{client_id}?CMID=#{cmid}"

        send_get_request request_url
      end

      def templates(options)
        request_url = "/kko/1/tamplate/list/#{client_id}?"
        if options.present?
          request_url += "TEMPLATE_CODE=##{options['template_code']}&" if options['template_code']
          request_url += "STATUS=#{options['status']}&" if options['status']
        end

        send_get_request request_url
      end

      def register_callback(send_phone_number, comment, pin_type = 'SMS')
        phone_number = send_phone_number.gsub("-", "")
        request_url = "/kko/1/sendnumber/save/#{client_id}?sendnumber=#{phone_number}&comment=#{comment}&pintype=#{pin_type}"

        send_get_request request_url
      end

      def verify_callback(send_phone_number, comment, pin_type, pin_code)
        phone_number = send_phone_number.gsub("-", "")
        request_url = "/kko/1/sendnumber/save/#{client_id}?sendnumber=#{phone_number}&comment=#{comment}&pintype=#{pin_type}&pincode=#{pin_code}"

        send_get_request request_url
      end

      def callbacks(send_phone_number = '')
        request_url = "/kko/1/sendnumber/list/#{client_id}?sendnumber=#{send_phone_number}"
        send_get_request request_url
      end

      def msg_test(phone_number, callback, msg, template_code, failed_type, options)
        request_url = "/kko/1/msg_test/#{client_id}"
        params = {
          'PHONE' => phone_number,
          'CALLBACK' => callback,
          'MSG' => msg,
          'TEMPLATE_CODE' => template_code,
          'FAILED_TYPE' => failed_type
        }

        if options.present?
          params['REQDATE'] = options['request_date'].strftime("%Y%m%d%H%M%S") if options['request_date']
          params['URL'] = options['url'] if options['url']
          params['URL_BUTTON_TXT'] = options['url_button_text'] if options['url_button_text']
          params['FAILED_SUBJECT'] = options['failed_subject'] if options['failed_subject']
          params['FAILED_MSG'] = options['failed_msg']
        end

        send_post_request request_url, params
      end

      private

      def send_post_request(url, params)
        conn = Faraday.new(BASE_URL)
        res = conn.post do |req|
          req.url url
          req.headers['x-waple-authorization'] = key
          req.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8'
          req.body = params
        end

        JSON.parse(res)
      end

      def send_get_request(url)
        conn = Faraday.new(BASE_URL)
        res = conn.get(url)

        JSON.parse(res)
      end
    end
  end
end

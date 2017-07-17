# Kth::Alimtalk

API스토어(https://www.apistore.co.kr/api/apiViewPrice.do?service_seq=558)에서 제공하는 카카오톡 알림톡 API를 구현한 gem.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kth-alimtalk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kth-alimtalk

## Usage

Create a client variable with your "API스토어ID" and "API Store Key".
```ruby
c = Kth::Alimtalk::Client.new("API스토어ID", "API STORE KEY")
```

### 알림톡 발송

```ruby
# phone_number: 수신할 핸드폰 번호
# callback: 발신자 전화번호
# msg: 전송할 메세지
# template_code: 카카오톡 알림톡 템플릿 코드
# failed_type: 전송 실패시 발송할 메세지 형태 (ex. SMS, LMS, N)
# options: {
#   request_date: 발송시간 (Time.new(2017, 07, 17, 19, 00, 00))
#   url: 알림톡 버튼 타입 URL (승인된 template 과 불일치시 전송실패)
#   url_button_text: 알림톡 버튼 타입 버튼 TEXT (승인된 template과 불일치시 전송실패)
#   failed_subject: 카카오알림톡 전송 실패 시 전송할 제목 (SMS 미사용)
#   failed_msg: 카카오알림톡 전송 실패 시 전송할 내용
#   params['REQDATE'] = options['request_date'].strftime("%Y%m%d%H%M%S") if options['request_date']
# }
c.send_message(phone_number, callback, msg, template_code, failed_type, options)
```

### 리포트 조회

```ruby
# cmid: 서버에서 생성한 request를 식별할 수 있는 유일한 키
c.report(cmid)
```

### 템플릿 조회

```ruby
# options: {
#   template_code: 템플릿코드 – 입력 안 할경우 전체 리스트 반환
#   status: 검수상태 – 입력 안 할경우 전체 리스트 반 환
#            등록(1) / 검수요청(2)
#            승인(3) / 반려(4) / 승인중단(5)
# }
c.templates(options)
```

### 발신번호 인증/등록

```ruby
# send_phone_number: 등록할 발신 번호
# comment: 메모 (200자)
# pin_type: 인증방법 (SMS. VMS 중 1개 선택)
c.register_callback(send_phone_number, comment, pin_type)


# 인증번호 확인 후 

# send_phone_number: 등록할 발신 번호
# comment: 메모 (200자)
# pin_type: 인증방법 (SMS. VMS 중 1개 선택)
# pin_code: 인증번호 (SMS 인증번호(6자리), VMS인증번호 (2자리))
c.verify_callback(send_phone_number, comment, pin_type, pin_code)
```

### 발신번호 리스트 조회

```ruby
# send_phone_number: 발신번호(“-“제외) – 입력 안 할경우 전체 리 스트 반환
c.callbacks(send_phone_number)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kth-alimtalk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kth::Alimtalk project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kth-alimtalk/blob/master/CODE_OF_CONDUCT.md).

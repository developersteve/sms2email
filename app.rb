require 'Telstra_Messaging'
require 'sendgrid-ruby'
include SendGrid
require 'sinatra'

class Application < Sinatra::Base

  get '/' do
    'hello world'
  end

  post '/' do
    params = JSON.parse request.body.read
    puts params['to']

    from = Email.new(email: 'from email here')
    to = Email.new(email: 'to email here')
    subject = 'SMS from ' + params['from'] + ' sent to ' + params['to']
    content = Content.new(type: 'text/plain', value: 'An sms from '+params['to'] + ' has been recieved with the following message > "' + params['body'] + '"')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: 'sendgrid token in here')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response
  end
end
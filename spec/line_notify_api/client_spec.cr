require "../spec_helper"
require "webmock"

module LineNotifyAPI
  describe Client do
    it "token" do
      client = Client.new("token")

      boundary = MIME::Multipart.generate_boundary

      body = convert_multipart_body(<<-BODY)
      --#{boundary}
      Content-Disposition: form-data; name="message"
      
      Hello, World!
      --#{boundary}--
      BODY

      headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

      WebMock.stub(:post, "https://notify-api.line.me/api/notify")
        .with(body: body, headers: headers)
        .to_return(body: "")

      client.notify("Hello, World!", boundary: boundary)

      body = convert_multipart_body(<<-BODY)
      --#{boundary}
      Content-Disposition: form-data; name="message"
      
      Hello, again!
      --#{boundary}--
      BODY

      headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

      WebMock.stub(:post, "https://notify-api.line.me/api/notify")
        .with(body: body, headers: headers)
        .to_return(body: "")

      client.notify("Hello, again!", boundary: boundary)
    end
  end
end

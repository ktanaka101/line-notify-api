require "./spec_helper"
require "webmock"

module LineNotifyAPI
  describe LineNotifyAPI do
    describe "Notify message" do
      it "Successful notification" do
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

        LineNotifyAPI.notify("token", "Hello, World!", boundary: boundary)
      end
    end

    describe "Notify image file with url" do
      it "Successful notification" do
        boundary = MIME::Multipart.generate_boundary

        body = convert_multipart_body(<<-BODY)
        --#{boundary}
        Content-Disposition: form-data; name="message"
        
        Hello, World!
        --#{boundary}
        Content-Disposition: form-data; name="imageFullsize"
        
        http://example.com/orig.jpg
        --#{boundary}--
        BODY

        headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

        WebMock.stub(:post, "https://notify-api.line.me/api/notify")
          .with(body: body, headers: headers)
          .to_return(body: "")

        LineNotifyAPI.notify("token", "Hello, World!", img_file: "http://example.com/orig.jpg", boundary: boundary)
      end
    end

    describe "Notify image file with local file path" do
      it "Successful notification" do
        boundary = MIME::Multipart.generate_boundary

        body = convert_multipart_body(<<-BODY)
        --#{boundary}
        Content-Disposition: form-data; name="message"
        
        Hello, World!
        --#{boundary}
        Content-Disposition: form-data; name="imageFile"
        BODY

        body += "\r\n\r\n"
        File.open("./spec/img/hello_world.jpg") do |file|
          body += String.build do |s|
            IO.copy(file, s)
          end
        end
        body += "\r\n--#{boundary}--"

        headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

        WebMock.stub(:post, "https://notify-api.line.me/api/notify")
          .with(body: body, headers: headers)
          .to_return(body: "")

        LineNotifyAPI.notify("token", "Hello, World!", img_file: "./spec/img/hello_world.jpg", boundary: boundary)
      end
    end

    describe "Notify thmbnail" do
      it "Successful notification" do
        boundary = MIME::Multipart.generate_boundary

        body = convert_multipart_body(<<-BODY)
        --#{boundary}
        Content-Disposition: form-data; name="message"
        
        Hello, World!
        --#{boundary}
        Content-Disposition: form-data; name="imageThumbnail"
        
        http://example.com/img_thmb.jpg
        --#{boundary}--
        BODY

        headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

        WebMock.stub(:post, "https://notify-api.line.me/api/notify")
          .with(body: body, headers: headers)
          .to_return(body: "")

        LineNotifyAPI.notify("token", "Hello, World!", thumbnail: "http://example.com/img_thmb.jpg", boundary: boundary)
      end
    end

    describe "Notify sticker" do
      it "Successful notification" do
        boundary = MIME::Multipart.generate_boundary

        body = convert_multipart_body(<<-BODY)
        --#{boundary}
        Content-Disposition: form-data; name="message"
        
        Hello, World!
        --#{boundary}
        Content-Disposition: form-data; name="stickerPackageId"
        
        1
        --#{boundary}
        Content-Disposition: form-data; name="stickerId"
        
        2
        --#{boundary}--
        BODY

        headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

        WebMock.stub(:post, "https://notify-api.line.me/api/notify")
          .with(body: body, headers: headers)
          .to_return(body: "")

        LineNotifyAPI.notify("token", "Hello, World!", stk_pkg_id: 1, stk_id: 2, boundary: boundary)
      end
    end

    describe "Notify thumbnail and image file and sticker" do
      it "Successful notification" do
        boundary = MIME::Multipart.generate_boundary

        body = convert_multipart_body(<<-BODY)
        --#{boundary}
        Content-Disposition: form-data; name="message"
        
        Hello, World!
        --#{boundary}
        Content-Disposition: form-data; name="stickerPackageId"
        
        1
        --#{boundary}
        Content-Disposition: form-data; name="stickerId"
        
        2
        --#{boundary}
        Content-Disposition: form-data; name="imageThumbnail"
        
        http://example.com/tmb.jpg
        --#{boundary}
        Content-Disposition: form-data; name="imageFullsize"
        
        http://example.com/orig.jpg
        --#{boundary}--
        BODY

        headers = {"Content-Type" => "multipart/form-data; boundary=\"#{boundary}\"", "Authorization" => "Bearer token"}

        WebMock.stub(:post, "https://notify-api.line.me/api/notify")
          .with(body: body, headers: headers)
          .to_return(body: "")

        LineNotifyAPI.notify("token", "Hello, World!", thumbnail: "http://example.com/tmb.jpg", img_file: "http://example.com/orig.jpg", stk_pkg_id: 1, stk_id: 2, boundary: boundary)
      end
    end
  end
end

def convert_multipart_body(str : String) : String
  str.each_line.map(&.+ "\r\n").join.chomp
end

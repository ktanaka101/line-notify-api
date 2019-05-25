require "./notify_api/*"
require "http/client"

module Line::NotifyAPI
  # Use the LINENotify API to notify.
  # See: https://notify-bot.line.me/doc/en/
  #
  # Send the specified *token*. Specify the *token* obtained by LINE Notify.
  #
  # Send the specified *message*.
  #
  # Send the specified *thumbnail*.
  #
  # Send the specified *img_file*.
  # NOTE: That it will be sent as "imageFullSize" for File path and as "imageFile" for URL.
  #
  # Send specified "stk_pkg_id" as "stickerPacketId".
  #
  # Send specified "stk_id" as "stickerId".
  #
  # *boundary* is used as a boundary of multipart/form-data.
  # This was defined for testing.
  def self.notify(token : String, message : String, *, thumbnail : String? = nil, img_file : String? = nil, stk_pkg_id : Int32? = nil, stk_id : Int32? = nil, boundary : String = MIME::Multipart.generate_boundary) : HTTP::Client::Response
    io = IO::Memory.new
    builder = HTTP::FormData::Builder.new(io, boundary)
    builder.field("message", message)

    builder.field("stickerPackageId", stk_pkg_id) if stk_pkg_id
    builder.field("stickerId", stk_id) if stk_id
    builder.field("imageThumbnail", thumbnail) if thumbnail

    if img_file
      if File.exists?(img_file)
        File.open(img_file) do |file|
          builder.file("imageFile", file)
        end
      else
        builder.field("imageFullsize", img_file)
      end
    end

    builder.finish

    HTTP::Client.post(
      "https://notify-api.line.me/api/notify",
      headers: HTTP::Headers{
        "Content-Type"  => builder.content_type,
        "Authorization" => "Bearer #{token}",
      },
      body: io.to_s
    )
  end
end

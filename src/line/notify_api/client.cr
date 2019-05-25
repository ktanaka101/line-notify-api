module Line::NotifyAPI
  class Client
    # It is a client for sending to "LINE Notify API".
    # In order to hold the token of the argument, it is efficient to use Client when dealing with the same token.
    #
    # Send the specified *token*. Specify the *token* obtained by LINE Notify.
    def initialize(@token : String)
    end

    # Pass an instance creation token and an argument of this method to `NotifyAPI.notify`.
    def notify(message, *, thumbnail = nil, img_file = nil, stk_pkg_id = nil, stk_id = nil, boundary = MIME::Multipart.generate_boundary) : HTTP::Client::Response
      NotifyAPI.notify(@token, message, thumbnail: thumbnail, img_file: img_file, stk_pkg_id: stk_pkg_id, stk_id: stk_id, boundary: boundary)
    end
  end
end

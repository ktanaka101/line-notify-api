# line-notify-api

Client for LINE notifiy API by Crystal.

The specifications of the Line Notify API can be checked at the following URL.

https://notify-bot.line.me/doc/en/

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     line-notify-api:
       github: ktanaka101/line-notify-api
   ```

2. Run `shards install`

## Usage

### Notify message

#### Notify the specified string

```crystal
require "line-notify-api"

client = LINE::NotifyAPI::Client.new(YOUR_LINE_ACCESS_TOKEN)
client.notify("Hello, World!")
```

### Notify image file

#### Thumbnail

```crystal
require "line-notify-api"

client = LINE::NotifyAPI::Client.new(YOUR_LINE_ACCESS_TOKEN)
client.notify("Hello, World!", thumbnail: "https://example.com/tmb.jpg", img_file: "https://example.com/orig.jpg")
```

#### Original size

```crystal
require "line-notify-api"

client = LINE::NotifyAPI::Client.new(YOUR_LINE_ACCESS_TOKEN)
client.notify("Hello, World!", img_file: "https://example.com/orig.jpg")
```

```crystal
require "line-notify-api"

client = LINE::NotifyAPI::Client.new(YOUR_LINE_ACCESS_TOKEN)
client.notify("Hello, World!", img_file: "/path/orig.jpg")
```

### Notify sticker

```crystal
require "line-notify-api"

client = LINE::NotifyAPI::Client.new(YOUR_LINE_ACCESS_TOKEN)
client.notify("Hello, World!", stk_pkg_id: 1, stk_id: 1)
```

### You can not use the client. In that case it has the same functionality as the client

```crystal
require "line-notify-api"

LINE::NotifyAPI.notify(YOUR_LINE_ACCESS_TOKEN, "Hello, World!")
```

```crystal
require "line-notify-api"

LINE::NotifyAPI.notify(
  YOUR_LINE_ACCESS_TOKEN,
  "Hello, World!",
  thumbnail: "https://example.com/tmb.jpg",
  img_file: "https://example.com/orig.jpg"
)
```

## Contributing

1. Fork it (<https://github.com/ktanaka101/line-notify-api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [ktanaka101](https://github.com/ktanaka101) Kentaro Tanaka - creator and maintainer

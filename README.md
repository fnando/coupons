# Coupons

[![Build Status](https://img.shields.io/travis/fnando/coupons/master.svg)](https://travis-ci.org/fnando/coupons)
[![Code Climate](https://img.shields.io/codeclimate/github/fnando/coupons.svg)](https://codeclimate.com/github/fnando/coupons)
[![Test Coverage](https://img.shields.io/codeclimate/coverage/github/fnando/coupons.svg)](https://codeclimate.com/github/fnando/coupons)
[![Gem Version](https://img.shields.io/gem/v/coupons.svg)](https://rubygems.org/gems/coupons)
[![Dependencies](https://img.shields.io/gemnasium/fnando/coupons.svg)](https://rubygems.org/gems/coupons)

Coupons is a Rails engine for creating discount coupons.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coupons'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coupons

## Usage

After installing `Coupons`, add the following line to your `config/routes.rb` file.

```ruby
mount Coupons::Engine => '/', as: 'coupons_engine'
```

You can visit `/coupons` to access the dashboard.

## Creating coupons

There are two types of coupons: percentage or amount.

- **percentage**: applies the percentage discount to total amount.
- **amount**: applies the amount discount to the total amount.

### Defining the coupon code format

The coupon code is generated with `Coupons.configuration.generator`. By default, it creates a 6-chars long uppercased alpha-numeric code. You can use any object that implements the `call` method and returns a string. The following implementation generates coupon codes like `AWESOME-B7CB`.

```ruby
Coupons.configure do |config|
  config.generator = proc do
    token = SecureRandom.hex[0, 4].upcase
    "AWESOME-#{token}"
  end
end
```

You can always override the generated coupon code through the dashboard or Ruby.

### Working with coupons

Imagine that you created the coupon `RAILSCONF15` as a $100 discount; you can apply it to any amount using the `Coupons.apply` method. Notice that this method won't redeem the coupon code and it's supposed to be used on the checkout page.

```ruby
Coupons.apply('RAILSCONF15', amount: 600.00)
#=> {:amount => 600.0, :discount => 100.0, :total => 500.0}
```

When a coupon is invalid/non-redeemable, it returns the discount amount as `0`.

```ruby
Coupons.apply('invalid', amount: 100.00)
#=> {:amount => 100.0, :discount => 0, :total => 100.0}
```

To redeem the coupon you can use `Coupon.redeem`.

```ruby
Coupons.redeem('RAILSCONF15', amount: 600.00)
#=> {:amount => 600.0, :discount => 100.0, :total => 500.0}

coupon = Coupons::Models::Coupon.last

coupon.redemptions_count
#=> 1

coupon.redemptions
#=> [#<Coupons::Models::CouponRedemption:0x0000010e388290>]
```

### Defining the coupon finder strategy

By default, the first redeemable coupon is used. You can set any of the following strategies.

- `Coupons::Finders::FirstAvailable`: returns the first redeemable coupon available.
- `Coupons::Finders::SmallerDiscount`: returns the smaller redeemable discount available.
- `Coupons::Finders::LargerDiscount`: returns the larger redeemable discount available.

To define a different strategy, set the `Coupons.configurable.finder` attribute.

```ruby
Coupons.configure do |config|
  config.finder = Coupons::Finders::SmallerDiscount
end
```

A finder can be any object that receives the coupon code and the options (which must include the `amount` key). Here's how the smaller discount finder is implemented.

```ruby
module Coupons
  module Finders
    SmallerDiscount = proc do |code, options = {}|
      coupons = Models::Coupon.where(code: code).all.select(&:redeemable?)

      coupons.min do |a, b|
        a = a.apply(options)
        b = b.apply(options)

        a[:discount] <=> b[:discount]
      end
    end
  end
end
```

#### Injecting helper methods

The whole coupon interaction can be made through some helpers methods. You can extend any object with `Coupons::Helpers` module. So do it in your initializer file or in your controller, whatever suits you best.

```ruby
coupons = Object.new.extend(Coupons::Helpers)
```

Now you can do all the interactions through the `coupons` variable.

### Authorizing access to the dashboard

Coupons has a flexible authorization system, meaning you can do whatever you want. All you have to do is defining the authorization strategy by setting `Coupons.configuration.authorizer`. By default, it disables access to the `production` environment, as you can see below.

```ruby
Coupons.configure do |config|
  config.authorizer = proc do |controller|
    if Rails.env.production?
      controller.render(
        text: 'Coupons: not enabled in production environments',
        status: 403
      )
    end
  end
end
```

To define your own strategy, like doing basic authentication, you can do something like this:

```ruby
Coupons.configure do |config|
  config.authorizer = proc do |controller|
    controller.authenticate_or_request_with_http_basic do |user, password|
      user == 'admin' && password == 'sekret'
    end
  end
end
```

### Attaching coupons to given records

To be written.

### Creating complex discount rules

To be written.

### JSON endpoint

You may want to apply discounts using AJAX, so you can give instant feedback. In this case, you'll find the `/coupons/apply` endpoint useful.

```javascript
var response = $.get('/coupons/apply', {amount: 600.0, coupon: 'RAILSCONF15'});
response.done(function(options)) {
  console.log(options);
  //=> {amount: 600.0, discount: 100.0, total: 500.0}
});
```

If you provide invalid amount/coupon, then it'll return zero values, like `{amount: 0, discount: 0, total: 0}`.

### I18n support

Coupons uses [I18n](http://guides.rubyonrails.org/i18n.html). It has support for `en` and `pt-BR`. You can contribute with your language by translating the file [config/en.yml](https://github.com/fnando/coupons/blob/master/config/locale/en.yml).

## Screenshots

![Viewing existing coupons](https://github.com/fnando/coupons/raw/master/screenshots/coupons-index.png)

![Creating coupon](https://github.com/fnando/coupons/raw/master/screenshots/coupons-new.png)

## Contributing

1. Before implementing anything, create an issue to discuss your idea. This only applies to big changes and new features.
2. Fork it ( https://github.com/fnando/coupons/fork )
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

# Give $10 discount when buying a Ruby book.
class CategoryResolver
  def resolve(coupon, options)
    category = options[:category]
    book = options[:book]

    return options if category.blank? && book.blank?

    category = book.category if book

    if category.name == 'Ruby'
      options[:discount] = 10
      options[:total] = options[:amount] - options[:discount]
    end

    options
  end
end

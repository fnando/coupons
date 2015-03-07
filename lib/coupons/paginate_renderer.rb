module Coupons
  class PaginateRenderer < Paginate::Renderer::List
    def previous_label
      I18n.t("coupons.paginate.previous")
    end

    def next_label
      I18n.t("coupons.paginate.next")
    end

    def page_label
      I18n.t("coupons.paginate.page", page: processor.page)
    end
  end
end

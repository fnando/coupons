module Coupons
  class FormBuilder < ActionView::Helpers::FormBuilder
    def hint(attribute, message = '')
      scope = ['coupons', 'hints', object.model_name.element].join('.').to_sym
      hint = I18n.t(attribute, scope: scope, default: message)
      @template.content_tag(:span, hint, class: 'hint') unless hint.blank?
    end

    def error_for(attribute)
      message = object.errors[attribute].first
      @template.content_tag(:span, message, class: 'error-message') unless message.blank?
    end

    def label(attribute, label = nil)
      scope = ['coupons', 'labels', object.model_name.element].join('.').to_sym
      label ||= I18n.t(attribute, scope: scope, default: attribute.to_s.humanize)

      super(attribute, label)
    end
  end
end

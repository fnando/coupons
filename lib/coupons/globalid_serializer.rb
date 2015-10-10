module Coupons
  class GlobalidSerializer
    def self.load(attachments)
      return {} unless attachments
      attachments = JSON.load(attachments)

      attachments.each_with_object({}) do |(key, uri), buffer|
        buffer[key.to_sym] = GlobalID::Locator
                              .locate_many([uri], ignore_missing: true)
                              .first
      end
    end

    def self.dump(attachments)
      attachments = attachments.each_with_object({}) do |(key, record), buffer|
        buffer[key] = record.to_global_id.to_s
      end

      JSON.dump(attachments)
    end
  end
end

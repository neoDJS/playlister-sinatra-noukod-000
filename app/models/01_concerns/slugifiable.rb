module Slugifiable
  module InstanceMethods
    def slug
      self.name.gsub(/\W/, "-").downcase
    end
  end

  module ClassMethods
    def find_by_slug(slugified)
      find{|e| e.slug == slugified}
    end
  end
end

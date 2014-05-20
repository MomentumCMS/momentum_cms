module MomentumCms

  class Error < StandardError
  end

  class RecordNotFound < MomentumCms::Error
    def initialize(identifier)
      super "Cannot find CMS Record: #{identifier}"
    end
  end

  class SiteNotFound < MomentumCms::Error
    def initialize(identifier)
      super "Cannot find CMS Site with host: #{identifier}"
    end
  end
  
  
  class PermanentObject < MomentumCms::Error
    def initialize(identifier)
      super "Cannot find CMS Site with host: #{identifier}"
    end
  end

  class CmsTagError < MomentumCms::Error
  end
end
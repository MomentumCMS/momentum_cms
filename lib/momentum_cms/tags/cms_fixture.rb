module MomentumCms
  module Tags
    class CmsFixture < CmsBaseBlock

      def self.get_contents(tag)
        results = if tag.is_a?(MomentumCms::Tags::CmsFixture)
                    results = ''
                    tag.nodelist.each do |node|
                      case node
                        when Liquid::Raw
                          node.nodelist.each do |node_raw|
                            results << node_raw
                          end
                        else
                          results << node
                      end
                    end
                    results
                  else
                    ''
                  end
        results.strip
      end

    end
    Liquid::Template.register_tag 'cms_fixture', CmsFixture
  end
end
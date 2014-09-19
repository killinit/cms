module Cms
  module ViewMethods
    module Helpers
      def cms_mirror_options(object=nil)

        options = case object
        when ::Comfy::Cms::Layout
          object.mirrors.collect{|m| [m.site.label, edit_comfy_admin_cms_site_layout_path(m.site, m)]}
        when ::Comfy::Cms::Page
          object.mirrors.collect{|m| [m.site.label, edit_comfy_admin_cms_site_page_path(m.site, m)]}
        when ::Comfy::Cms::Snippet
          object.mirrors.collect{|m| [m.site.label, edit_comfy_admin_cms_site_snippet_path(m.site, m)]}
        else
          (::Comfy::Cms::Site.mirrored - [@site]).collect{|s| [s.label, url_for(params.merge(:site_id => s.id))]}
        end
        options = [[@site.label, request.fullpath]] + options

        if options.count > 1
          en = options.find {|o| o.first.match(/en/i) }
          cy = options.find {|o| o.first.match(/cy/i) }
        end

        [en, cy]
      end
    end
  end
  ActionView::Base.send :include, Cms::ViewMethods::Helpers
end
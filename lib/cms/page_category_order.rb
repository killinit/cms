require 'csv'

class PageCategoryOrder
  def call
    CSV.open("#{Rails.root}/lib/cms/page_order.csv", headers: true).each do |row|

      category = Comfy::Cms::Category.find_by(label: row['category'])
      page = Comfy::Cms::Page.find_by(slug: row['article'])
      ordinal = row['ordinal']

      if page && category
        categorization = Comfy::Cms::Categorization.find_by(
          category_id: category.id,
          categorized_id: page.id
        )
      else
        puts "can't find #{row['category']} / #{row['article']}"
      end

      if categorization
        categorization.update_attributes(ordinal: ordinal)
      else
        puts "unknown categorization for category: #{category.try(:label)}, page: #{page.try(:slug)}"
      end
    end
  end
end

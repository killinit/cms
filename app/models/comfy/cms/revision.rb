require ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'revision.rb')

class Comfy::Cms::Revision < ActiveRecord::Base
  belongs_to :author, foreign_key: 'author_id', class_name: 'Comfy::Cms::User'
end

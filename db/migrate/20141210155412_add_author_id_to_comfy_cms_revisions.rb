class AddAuthorIdToComfyCmsRevisions < ActiveRecord::Migration
  def change
    add_column :comfy_cms_revisions, :author_id, :integer
    add_index :comfy_cms_revisions, :author_id
  end
end

class <%= migration_name %> < ActiveRecord::Migration
  
  def self.up
    create_table "paperclipped_assets", :force => true do |t|  
      t.integer  :attachable_id
      t.string   :attachable_type
      t.string   :attachable_association_name

      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.datetime :date_updated_at
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index "paperclipped_assets", ["attachable_id", "attachable_type"], :name => "index_paperclipped_assets_on_attachable_id_and_attachable_type"

  end
  
  def self.down
    drop_table :paperclipped_assets    
  end
end


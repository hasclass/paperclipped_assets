ActiveRecord::Schema.define(:version => 0) do
  create_table "mock_clients", :force => true do |t|
    t.string   "title"
    t.text     "body"
  end

  create_table "mock_users", :force => true do |t|
    t.string   "title"
    t.text     "body"
  end

  create_table "paperclipped_assets", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "attachable_association_name"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "date_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

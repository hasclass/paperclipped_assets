require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))
ActiveRecord::Base.establish_connection(databases[ENV["DB"] || "sqlite3"])
load(File.join(plugin_spec_dir, "db/schema.rb"))


def uploaded_file(path, content_type="application/octet-stream", filename=nil)
  filename ||= File.basename(path)
  t = Tempfile.new(filename)
  FileUtils.copy_file(path, t.path)
  (class << t; self; end;).class_eval do
    alias local_path path
    define_method(:original_filename) { filename }
    define_method(:content_type) { content_type }
  end
  return t
end

class MockClient < ActiveRecord::Base
  has_paperclipped_asset :logo
end

class MockUser < ActiveRecord::Base
  has_paperclipped_asset :file1
  has_paperclipped_asset :file2  
end


# A JPEG helper
def uploaded_jpeg(path, filename = nil)
  uploaded_file(path, 'image/jpeg', filename)
end

# A TXT helper
def uploaded_txt(path, filename = nil)
  uploaded_file(path, 'text/plain', filename)
end

#def create_asset(opts = {})
#  lambda do
#    @asset = PaperclippedAsset.create(opts)
#  end.should change(PaperclippedAsset, :count).by(1)
#  @asset
#end


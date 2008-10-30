require File.dirname(__FILE__) + '/lib/has_paperclipped_asset'
ActiveRecord::Base.send(:include, HasClass::Acts::HasPaperclippedAsset)
require File.dirname(__FILE__) + '/lib/paperclipped_asset'

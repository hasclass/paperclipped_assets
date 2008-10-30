class PaperclippedAsset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  has_attached_file :data,
                    :styles => { :thumb   => "64x64#",
                                 :small  => "176x112#",
                                 :medium => "630x630>",
                                 :large  => "1024x1024>" },
                    :url    => "/assets/:id/:style/:basename.:extension",
                    :path   => ":rails_root/public/assets/:id/:style/:basename.:extension"                                 
  def url(*args)
    data.url(*args)
  end
  
  def name
    data_file_name
  end
  
  def content_type
    data_content_type
  end
  
  def browser_safe?
    %w(jpg jpeg gif png).include?(url.split('.').last.downcase)
  end  
  alias_method :web_safe?, :browser_safe?
  
  # This method assumes you have images that corespond to the filetypes.
  # For example "image/png" becomes "image-png.png"
  def icon
    "#{data_content_type.gsub(/[\/\.]/,'-')}.png"
  end

  def to_s
    url
  end

end
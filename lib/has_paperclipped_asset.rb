module HasClass
  module Acts #:nodoc: all
    module HasPaperclippedAsset
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Extends the model to afford the ability to associate other records with the receiving record.
        # This module needs the paperclip plugin to work
        # http://www.thoughtbot.com/projects/paperclip
        def has_paperclipped_asset(name = :paperclipped_asset, association_options = {}) 
          include InstanceMethods

          write_inheritable_attribute(:paperclipped_asset_definitions, {}) if paperclipped_asset_definitions.nil?

          #association_options[:polymorphic] = true
          association_options[:as]          = :attachable
          association_options[:class_name]  = 'PaperclippedAsset'
          association_options[:dependent]  ||= :destroy
          association_options[:conditions] ||= "paperclipped_assets.attachable_association_name = '#{name}'"
          
          # only do once
          has_many :paperclipped_assets, :as => :attachable # TODO: check if already defined unless paperclipped_assets.nil?
          has_one name, association_options
          
          after_save :save_paperclipped_assets
                  
          
          # Virtual attribute for the ActionController::UploadedStringIO
          # which consists of these attributes "content_type", "original_filename" & "original_path"
          # content_type: image/png
          # original_filename: 64x16.png
          # original_path: 64x16.png          
          attr_accessor "#{name}_data".to_sym # data_attribute_name
          paperclipped_asset_definitions[name] = ("#{name}_data").to_sym
          
        end
        
        # Returns the attachment definitions defined by each call to has_attached_file.
        def paperclipped_asset_definitions
          read_inheritable_attribute(:paperclipped_asset_definitions)
        end
      end
      
      module InstanceMethods                
        def each_paperclipped_asset
          self.class.paperclipped_asset_definitions.each do |name, data_attribute_name|
            yield(name, self.send(name),data_attribute_name)
          end
        end

        def save_paperclipped_assets
          logger.info("[paperclipped_asset] Saving assets.")
          each_paperclipped_asset do |name, paperclipped_asset, data_attribute_name|
            data = self.send(data_attribute_name)
            if data 
              paperclipped_asset ||= self.send("build_#{name}")
              
              paperclipped_asset.attachable_association_name = name.to_s
              paperclipped_asset.data = data
              paperclipped_asset.save(false)
            end #if
          end          
        end
        
        
      end # InstanceMethods
    end
  end
end
      

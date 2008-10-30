class PaperclippedAssetGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end
  
  def manifest
    recorded_session = record do |m|   
   
      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', 
         :assigns => { :migration_name => "PaperclippedAssetMigration" },
         :migration_file_name => "paperclipped_asset_migration"
      end
    end
    
    action = nil
    action = $0.split("/")[1]
    case action
      when "generate" 
        puts
        puts ("-" * 70)
        puts "Don't forget to rake db:migrate"
        puts ("-" * 70)
        puts
      else
        puts
    end

    recorded_session  end
  
  def has_rspec?
    options[:rspec] || (File.exist?('spec') && File.directory?('spec'))
  end
  
end

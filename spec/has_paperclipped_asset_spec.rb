require File.dirname(__FILE__) + '/spec_helper'

describe MockClient, :type => :model do
  before(:each) do
   @uploaded_image  = uploaded_jpeg("#{File.dirname(__FILE__)}/fixtures/assets/rails.png")
   @uploaded_text   = uploaded_txt("#{File.dirname(__FILE__)}/fixtures/assets/sample.txt")
   
   @client = MockClient.new(:title => 'foo', :logo_data => @uploaded_image)
   @user = MockUser.new(:title => 'foo', :file1_data => @uploaded_image, :file2_data => @uploaded_image)
 end
 
 describe 'when being saved' do
   it 'should create an asset after being saved' do
     lambda do
       @client.save
     end.should change(PaperclippedAsset, :count).by(1)
   end
   
   it 'should create a paperclipped_asset for every defined after being saved' do
     lambda do
       @user.save
     end.should change(PaperclippedAsset, :count).by(2)
   end
   
   it 'should not create a paperclipped_asset if no data passed after being saved' do
     lambda do
       MockUser.create(:title => 'foo', :file1_data => @uploaded_image)
     end.should change(PaperclippedAsset, :count).by(1)
   end    
 end
 
  describe 'when being deleted' do
    it 'should delete attached assets' do
      lambda do
        @client.save
      end.should change(PaperclippedAsset, :count).by(1)
      
      lambda do
        @client.destroy
        lambda do
          MockClient.find(@client)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end.should change(PaperclippedAsset, :count)
    end
    
    it 'should delete all attached assets' do
      lambda do
        @user.save
      end.should change(PaperclippedAsset, :count).by(2)
      
      lambda do
        @user.destroy
        lambda do
          MockClient.find(@user)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end.should change(PaperclippedAsset, :count).by(-2)
    end
    
  end
   
 
# describe 'when being attached to a model with content-type restrictions' do
#   it 'should allow only files of the accepted type to be saved and attached'
# end
end

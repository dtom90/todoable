require 'spec_helper'

RSpec.describe Todoable do
  it 'has a version number' do
    expect(Todoable::VERSION).not_to be nil
  end
  
  before(:all) do
    @service = Todoable::Service.new(ENV['username'], ENV['password'])
    @list_id = 'foo'
  end
  
  it 'gets a temporary token from the service' do
    token = @service.token
    expect(token).to match(/[a-z,0-9,\-]+/)
  end
  
  it 'gets the lists from the service' do
    lists = @service.get_lists
    expect(lists).to be_a(Array)
  end
  
  it 'creates a new list, gets info of the list, renames it, deletes it' do
    
    # create a new list
    list_name       = "Test list #{Time.now}"
    create_response = @service.create_list list_name
    expect(create_response).to be(true)
    
    # get all lists and check that a list with the name exists
    lists = @service.get_lists
    list_idx   = names_of(lists).index list_name
    expect(lists[list_idx]['name']).to eq(list_name)
    
    # get the id of the newly created list
    list_id = lists[list_idx]['id']
    expect(lists[list_idx]['id']).to match(/[a-z,0-9,\-]+/)
    
    # get info of the created list from the id
    list_info = @service.get_list list_id
    expect(list_info).to be_a Hash
    expect(list_info).to have_key 'items'
    expect(list_info['items']).to be_a Array
    
    # rename the list, then get the info and check new name
    list_rename     = list_name+' RENAMED'
    rename_response = @service.rename_list(list_id, list_rename)
    expect(rename_response).to be(true)
    list_info = @service.get_list list_id
    expect(list_info['name']).to eq(list_rename)
    
    # delete the list then check that it is deleted
    expect(names_of(@service.get_lists)).to include(list_rename)
    @service.delete_list list_id
    expect(names_of(@service.get_lists)).not_to include(list_rename)
  
  end
  
  it 'creates a new list, creates an item, marks it as done, then deletes it' do
    
    # create a new list
    list_name       = "Test list #{Time.now}"
    create_response = @service.create_list list_name
    expect(create_response).to be(true)
    
    # get the list id
    lists   = @service.get_lists
    list_id = lists[names_of(lists).index(list_name)]['id']
    
    # create new item
    item_name = "New Item #{Time.now}"
    @service.create_item list_id, item_name
    
    # confirm creation of item
    list_info  = @service.get_list list_id
    items      = list_info['items']
    item_idx = names_of(items).index item_name
    expect(items[item_idx]['name']).to eq item_name
    
    # mark the item as finished
    item_id = items[item_idx]['id']
    expect(@service.get_list(list_id)['items'][item_idx]['finished_at']).to be(nil)
    expect(@service.mark_item_finished(list_id, item_id)).to eq(true)
    expect(@service.get_list(list_id)['items'][item_idx]['finished_at']).to_not be(nil)
    
    # delete the item
    expect(@service.delete_item(list_id, item_id)).to eq(true)
    expect(names_of(@service.get_list(list_id)['items'])).not_to include list_name
    
  end

end

def names_of(list)
  list.map { |element| element['name'] }
end
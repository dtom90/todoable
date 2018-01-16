require 'todoable/version'
require 'httparty'

module Todoable
  
  class Service
    include HTTParty
    base_uri 'https://todoable.teachable.tech/api'
    format :json
    
    def initialize(username, password)
      @username = username
      @password = password
      @token = get_token
      @options = {headers: {'Authorization' => "Token token=\"#{@token}\""}}
    end
    
    def token
      @token
    end
    
    def get_lists
      self.class.get('/lists', @options).parsed_response['lists']
    end
    
    def create_list(name)
      self.class.post('/lists', name_options('list', name)).response.code == '201'
    end
    
    def get_list(list_id)
      self.class.get("/lists/#{list_id}", @options).parsed_response
    end
    
    def rename_list(list_id, name)
      self.class.patch("/lists/#{list_id}", name_options('list', name)).response.code == '200'
    end
    
    def delete_list(list_id)
      self.class.delete("/lists/#{list_id}", @options).response.code == '204'
    end
    
    def create_item(list_id, name)
      self.class.post("/lists/#{list_id}/items", name_options('item', name)).response.code == '201'
    end

    def mark_item_finished(list_id, item_id)
      self.class.put("/lists/#{list_id}/items/#{item_id}/finish", @options).response.code == '200'
    end
    
    def delete_item(list_id, item_id)
      self.class.delete("/lists/#{list_id}/items/#{item_id}", @options).response.code == '204'
    end
    
    private
    
    def name_options(attr, name)
      @options.merge body: {attr => {name: name}}.to_json
    end
    
    def get_token
      options = {
        basic_auth: {username: @username, password: @password}
      }
      self.class.post('/authenticate', options).parsed_response['token']
    end
  
  end

end

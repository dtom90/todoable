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
      response = self.class.get('/lists', @options)
      expect_code response, 200
      response.parsed_response['lists']
    end
    
    def create_list(name)
      response = self.class.post '/lists', name_options('list', name)
      expect_code response, 201
    end
    
    def get_list(list_id)
      response = self.class.get("/lists/#{list_id}", @options)
      expect_code response, 200
      response.parsed_response
    end
    
    def rename_list(list_id, name)
      response = self.class.patch "/lists/#{list_id}", name_options('list', name)
      expect_code response, 200
    end
    
    def delete_list(list_id)
      response = self.class.delete "/lists/#{list_id}", @options
      expect_code response, 204
    end
    
    def create_item(list_id, name)
      response = self.class.post "/lists/#{list_id}/items", name_options('item', name)
      expect_code response, 201
    end

    def mark_item_finished(list_id, item_id)
      response = self.class.put "/lists/#{list_id}/items/#{item_id}/finish", @options
      expect_code response, 200
    end
    
    def delete_item(list_id, item_id)
      response = self.class.delete "/lists/#{list_id}/items/#{item_id}", @options
      expect_code response, 204
    end
    
    private
    
    def name_options(attr, name)
      @options.merge body: {attr => {name: name}}.to_json
    end
    
    def get_token
      options = {
        basic_auth: {username: @username, password: @password}
      }
      response = self.class.post('/authenticate', options)
      expect_code response, 200
      response.parsed_response['token']
    end
    
    def expect_code(response, expected_code)
      if response.code != expected_code
        case response.code
          when 401
            raise TodoableError.new('Unauthorized: credentials not recognized, or token expired')
          when 422
            raise TodoableError.new('Unprocessable Entity: The data you submitted could not be processed')
        end
      end
      true
    end
    
  end

end

class TodoableError < StandardError
end
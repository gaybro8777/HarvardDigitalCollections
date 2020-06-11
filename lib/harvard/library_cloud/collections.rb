module Harvard::LibraryCloud::Collections

  require 'faraday'
  require 'json'

  include Harvard::LibraryCloud

  # Logic for adding an item to a collection,
  def add_to_collection_action (collection, item)

    api = Harvard::LibraryCloud::API.new
    path = 'collections/' + collection

    connection = Faraday.new(:url => api.get_base_uri + path) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
      if current_or_guest_user.api_key.nil?
        faraday.headers['X-LibraryCloud-API-Key'] = ENV["LC_API_KEY"]
      else
        faraday.headers['X-LibraryCloud-API-Key'] = current_or_guest_user.api_key
      end
    end

    raw_response = begin
      response = connection.post do |req|
        req.body = '[{"item_id": "' + item + '"}]'
      end
      { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
  end

  # This is the action that displays the contents of the "Add to Collection" dialog
  def add_to_collection

    if request.post?
      # Actually add the item to the collection
      ids = request.params[:id].split(',')
      ids.each do |id|
        add_to_collection_action(request.params[:collection], id)
      end

      # Don't render the default "Add to Collection" dialog - render the "Success!" dialog contents
      flash[:success] ||= "The item has been added to the collection"
      render 'catalog/add_to_collection_success'
    end

  end

  # There is probably a better way to do this. Blacklight is calling a function with this name to render
  # the path for the "Add to Collection" action, but I'm not 100% sure why. According to the documentation
  # we would expect this function to be named 'add_to_collection_catalog_path'.
  def add_to_collection_solr_document_path (arg)
    "/catalog/" << arg.id << "/add_to_collection"
  end


  # Helper method to get the collections that are available for adding an item to
  # This does not currently do any filtering by ownership, so it shows ALL collections
  def available_collections
    api = Harvard::LibraryCloud::API.new
    path = 'collections/user'
    if current_or_guest_user.api_key.nil?
      user_key = ENV["LC_API_KEY"]
    else
      user_key = current_or_guest_user.api_key
    end
    raw_response = begin
      response = Faraday.get(api.get_base_uri + path) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LibraryCloud-API-Key'] = user_key
      end
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
    response_json = JSON.parse(response.body)
    response_json.map {|n| {"id" => n['systemId'], "title" => n['setName'], "setSpec" => n['setSpec'], "thumbnail" => n['thumbnailUrn'], "collectionSize" => n['collectionSize'], "last_updated" => n['modified']}}
  end

  def get_collection_by_id(systemId)
    api = Harvard::LibraryCloud::API.new
    path = 'collections/' + systemId.to_s
    if current_or_guest_user.api_key.nil?
      user_key = ENV["LC_API_KEY"]
    else
      user_key = current_or_guest_user.api_key
    end
    raw_response = begin
      response = Faraday.get(api.get_base_uri + path) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LibraryCloud-API-Key'] = user_key
      end
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
    response_json = JSON.parse(response.body)
    response_json.map {|n| {"id" => n['systemId'], "title" => n['setName'], "setSpec" => n['setSpec'], "thumbnail" => n['thumbnailUrn'], "collectionSize" => n['collectionSize'], "last_updated" => n['modified']}}
  end
  def create_library_cloud_user
      api = Harvard::LibraryCloud::API.new
      path = 'collections/users/'
      raw_response = begin
        response = Faraday.post(api.get_base_uri + path,
        '{"email": "' + current_or_guest_user.email + '","usertype-name":"HDC"}',
        "Content-Type" => "application/json",
        "X-LibraryCloud-API-Key" => ENV["LC_API_KEY"]
        )
        { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
      rescue Errno::ECONNREFUSED, Faraday::Error => e
        raise RSolr::Error::Http.new(connection, e.response)
      end
  end
  def delete_library_cloud_user
    api = Harvard::LibraryCloud::API.new
    path = 'collections/users'
    user_key = current_or_guest_user.api_key
    unless user_key.nil?
      raw_response = begin
        response = Faraday.delete(api.get_base_uri + path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-LibraryCloud-API-Key'] = user_key
        end
        { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
      rescue Errno::ECONNREFUSED, Faraday::Error => e
        raise RSolr::Error::Http.new(connection, e.response)
      end
    end
  end
  def create_collection (user_key, setName, thumbnailUrn)
      api = Harvard::LibraryCloud::API.new
      path = 'collections/'
      raw_response = begin
        response = Faraday.post(api.get_base_uri + path,
        '{"setName": "' + setName + '","setDescription": "'+ setName +'","thumbnailUrn": "'+ thumbnailUrn +'"}',
        "Content-Type" => "application/json",
        "X-LibraryCloud-API-Key" => user_key
        )
        { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
      rescue Errno::ECONNREFUSED, Faraday::Error => e
        raise RSolr::Error::Http.new(connection, e.response)
      end
  end

  def update_collection(user_key, systemId, setName)
    api = Harvard::LibraryCloud::API.new
    path = 'collections/' + systemId.to_s
    raw_response = begin
      response = Faraday.put(api.get_base_uri + path,
      '{"setName": "' + setName + '"}',
      "Content-Type" => "application/json",
      "X-LibraryCloud-API-Key" => user_key
      )
      { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
  end

  def destroy_collection(user_key, systemId)
    api = Harvard::LibraryCloud::API.new
    path = 'collections/' + systemId.to_s
    raw_response = begin
      response = Faraday.delete(api.get_base_uri + path) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LibraryCloud-API-Key'] = user_key
      end
      { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
  end

  def add_item_to_collection(user_key, listId, itemIds)
    api = Harvard::LibraryCloud::API.new
    path = 'collections/' + listId.to_s
    request_body = '['

    items_array = itemIds.split(',')
    items_array.each do |item|
      if request_body.length > 1
        request_body +=","
      end
      request_body += '{"item_id": "'+ item + '"}'
    end
    request_body += "]"

    raw_response = begin
      response = Faraday.post(api.get_base_uri + path) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LibraryCloud-API-Key'] = user_key
        req.body = request_body
      end
      { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
  end

  def delete_item_from_collection(user_key, listId, itemId)
    api = Harvard::LibraryCloud::API.new
    path = 'collections/' + listId.to_s + '/items/' + itemId.to_s
    raw_response = begin
      response = Faraday.delete(api.get_base_uri + path) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LibraryCloud-API-Key'] = user_key
      end
      { status: response.status.to_i, headers: response.headers, body: response.body.force_encoding('utf-8') }
    rescue Errno::ECONNREFUSED, Faraday::Error => e
      raise RSolr::Error::Http.new(connection, e.response)
    end
  end
end

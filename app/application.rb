class Application

  @@items = ["Apples","Carrots","Pears", "Figs"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    # We have access to all the information from the resource or path requested through the 'env' variable
    # The env variable is all of the information contained in the request
    req = Rack::Request.new(env)
    
    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/) # <= Looks for the 'search' key word in the URL.
      search_term = req.params["q"] # <= Looks for the key/value pair by the 'q' key in the URL and assigns it to search_term variable.
      resp.write handle_search(search_term) # <= Passes the search_term variable as an argument of the handle_search instance method
    elsif req.path.match(/cart/)
      if @@cart.size > 0
        resp.write "Here is your cart:"
        @@cart.each do |item|
          resp.write "#{item}\n"
        end  
      else 
        resp.write "Your cart is empty."
      end
    elsif req.path.match(/add/)
      selected_item = req.params["item"]
      resp.write add_item_to_cart(selected_item)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

    def handle_search(search_term)
      if @@items.include?(search_term) # <= Check if the class array contains the word enterd by the user.
        return "#{search_term} is one of our items"
      else
        return "Couldn't find #{search_term}"
      end
    end

    def add_item_to_cart(selected_item)
      if @@items.include?(selected_item)
        @@cart << selected_item
        return "added #{selected_item}"
      else
        return "We don't have that item"
      end
    end
end

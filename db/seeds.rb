require './app'

customer = Hectic::Models::Customer.new
customer.full_name = 'Virginia Woolf'
customer.save

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = 0
point.current_points = 4787
point.description = 'Customer made 40k purchases since its registration'
point.customer = customer
point.save
previous = point

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = previous.current_points
point.current_points = previous.current_points - 400
point.description = 'Customer was granted 40% discount'
point.customer = customer
point.save

customer = Hectic::Models::Customer.new
customer.full_name = 'Ewerton Assis'
customer.save

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = 0
point.current_points = 55
point.description = 'Customer made 100 purchases since its registration'
point.customer = customer
point.save

customer = Hectic::Models::Customer.new
customer.full_name = 'Charles Dickens'
customer.save

customer = Hectic::Models::Customer.new
customer.full_name = 'William Gibson'
customer.save

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = 0
point.current_points = 487
point.description = 'Customer made 400 purchases since its registration'
point.customer = customer
point.save
previous = point

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = previous.current_points
point.current_points = previous.current_points - 100
point.description = 'Customer was granted 10% discount'
point.customer = customer
point.save

customer = Hectic::Models::Customer.new
customer.full_name = 'Arthur C. Clarke'
customer.save

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = 0
point.current_points = 625
point.description = 'Customer made 10k purchases since its registration'
point.customer = customer
point.save

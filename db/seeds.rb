require './app'

customer = Hectic::Models::Customer.new
customer.full_name = 'Ewerton Assis'
customer.save

point = Hectic::Models::LoyaltyPoint.new
point.previous_points = 0
point.current_points = 10
point.description = 'Customer made 100 purchases since its registration'
point.customer = customer
point.save

update = Hectic::Models::LoyaltyPoint.new
update.previous_points = point.current_points
update.current_points = point.current_points - 5
update.description = 'Customer was granted a 10% discount'
update.customer = customer
update.save

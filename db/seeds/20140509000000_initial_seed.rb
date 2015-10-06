Sequel.seed do
  def run
    customer = Hectic::Models::Customer.create \
      full_name: 'Leo Tolstoy'

    customer = Hectic::Models::Customer.create \
      full_name: 'Virginia Woolf'

    previous = Hectic::Models::LoyaltyPoint.create \
      previous_points: 0,
      current_points: 4787,
      description: 'Customer made 40k purchases since its registration',
      customer: customer

    point = Hectic::Models::LoyaltyPoint.create \
      previous_points: previous.current_points,
      current_points: previous.current_points - 400,
      description: 'Customer was granted 40% discount',
      customer: customer

    customer = Hectic::Models::Customer.create \
      full_name: 'Ewerton Assis'

    point = Hectic::Models::LoyaltyPoint.create \
      previous_points: 0,
      current_points: 55,
      description: 'Customer made 100 purchases since its registration',
      customer: customer

    customer = Hectic::Models::Customer.create \
      full_name: 'Charles Dickens'

    customer = Hectic::Models::Customer.create \
      full_name: 'William Gibson'

    previous = Hectic::Models::LoyaltyPoint.create \
      previous_points: 0,
      current_points: 487,
      description: 'Customer made 400 purchases since its registration',
      customer: customer

    point = Hectic::Models::LoyaltyPoint.create \
      previous_points: previous.current_points,
      current_points: previous.current_points - 100,
      description: 'Customer was granted 10% discount',
      customer: customer

    customer = Hectic::Models::Customer.create \
      full_name: 'Arthur C. Clarke'

    point = Hectic::Models::LoyaltyPoint.create \
      previous_points: 0,
      current_points: 625,
      description: 'Customer made 10k purchases since its registration',
      customer: customer
  end
end

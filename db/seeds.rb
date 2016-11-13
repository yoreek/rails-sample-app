# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create accounts
(1..3).each do |i|
  Account.create(name: "Account ##{i}", email: "acc#{i}@mail.com")
end
account = Account.first

# Create plans
(1..3).each do |i|
  plan = Plan.create(name: "Plan ##{i}")

  # Create resources
  (1..3).each do |j|
    plan.plan_resources.create(
      name: "Resource ##{i}#{j}",
      amount: j
    )
  end

  # Create subscriptions and charges
  (1..5).each do |j|
    plan.subscriptions.create(
      name:       "Subscription ##{i}#{j}",
      account_id: account.id,
      start_date: Date.today
    )
  end
end

plan = Plan.first
resource = Plan.last.plan_resources.first

# Create resellers
(1..3).each do |i|
  reseller = Reseller.create(name: "Reseller ##{i}")

  # Create licensors
  (1..3).each do |j|
    licensor = reseller.licensors.create(
      name:   "Licensor ##{i}#{j}",
      status: :active
    )

    # Create licenses
    (1..5).each do |k|
      license = licensor.licenses.create(
        name:           "License ##{i}#{j}#{k}",
        sku:            'sku',
        licensing_type: :monthly,
        status:         :active
      )

      # Create license fees
      (1..2).each do |l|
        license.license_fees.create(
          start_date:   Date.today,
          amount:       l
        )
      end

      # Create license mappings
      license.license_mappings.create(
        mappable_id:    plan.id,
        mappable_type:  'Plan'
      )
      license.license_mappings.create(
        mappable_id:    resource.id,
        mappable_type:  'PlanResource'
      )
    end
  end
end

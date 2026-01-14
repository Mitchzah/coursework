demo_email = "demo@example.com"
demo_password = "password123"

User.find_or_create_by!(email: demo_email) do |user|
	user.full_name = "Demo User"
	user.password = demo_password
	user.password_confirmation = demo_password
end

secondary_users = [
	{ email: "alex@example.com", full_name: "Alex Traveler" },
	{ email: "blair@example.com", full_name: "Blair Companion" }
]

secondary_users.each do |attrs|
	User.find_or_create_by!(email: attrs[:email]) do |user|
		user.full_name = attrs[:full_name]
		user.password = demo_password
		user.password_confirmation = demo_password
	end
end

demo = User.find_by!(email: demo_email)
alex = User.find_by!(email: "alex@example.com")
blair = User.find_by!(email: "blair@example.com")

trip_definitions = [
	{ title: "Sunny Beach Weekend", multiplier: 1, base_amount: 100, start_date: Date.today - 20, end_date: Date.today - 17 },
	{ title: "Mountain Cabin Escape", multiplier: 2, base_amount: 100, start_date: Date.today - 14, end_date: Date.today - 11 },
	{ title: "City Food Tour", multiplier: 3, base_amount: 100, start_date: Date.today - 7, end_date: Date.today - 3 }
]

trip_definitions.each do |definition|
	total = definition[:base_amount] * definition[:multiplier]

	trip = Trip.find_or_create_by!(title: definition[:title], creator: demo) do |t|
		t.description = "Demo trip with total about #{total} USD"
		t.start_date = definition[:start_date]
		t.end_date = definition[:end_date]
		t.base_currency = "USD"
	end

	# Ensure dates/base_currency stay consistent on reruns
	trip.update!(
		description: "Demo trip with total about #{total} USD",
		start_date: definition[:start_date],
		end_date: definition[:end_date],
		base_currency: "USD"
	)

	# Trip members: demo is creator; add Alex & Blair as attendees
	[alex, blair].each do |attendee|
		TripMembership.find_or_create_by!(trip:, attendee: attendee)
	end

	# Clear existing expenses for idempotency, then recreate simple totals
	trip.expenses.destroy_all

	Expense.create!(
		trip: trip,
		payer: demo,
		amount: total,
		description: "Lodging + food package",
		category: "Lodging",
		incurred_date: trip.start_date + 1,
		raw_currency: "USD"
	)
end

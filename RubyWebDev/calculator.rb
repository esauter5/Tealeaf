puts "Starting Calculator app..."
puts "_______________________"

continue = true

until continue == false

	puts "\nPlease enter the first number:"
	num1 = gets.chomp

	puts "Please enter the operator symbol: +, -, *, or /"
	operator = gets.chomp

	puts "Please enter the second number:"
	num2 = gets.chomp

	result = nil

	case operator
		when '+'
			result = num1.to_f + num2.to_f
		when '-'
			result = num1.to_f - num2.to_f
		when '*'
			result = num1.to_f * num2.to_f
		when '/'
			result = num1.to_f / num2.to_f
	end

	puts "#{num1} #{operator} #{num2} = #{result}"

	puts "\nPerform another calculation? (Yes/No)"
	choice = gets.chomp.downcase

	case choice
		when 'yes'
			continue = true
		when 'no'
			continue = false
	end
end

puts "\nExiting Calculator app....."
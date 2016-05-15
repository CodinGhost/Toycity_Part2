rewuire 'date'
require 'json'
path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

# Print "Sales Report" in ascii art

# Print today's date
current_time = DateTime.now.strftime('%m/%d/%y')

puts "Today's Date: #{current_time}"

# Print "Products" in ascii art

# For each product in the data set:
products_hash["items"].each do |product|
	i = 0
	amount_sales = []
	total_retail = product["full-price"].to_f * product["purchases"].length
	# Print the name of the toy
	puts product["title"]
	# Print the retail price of the toy
	puts "Retail Price: $#{product["full-price"]}"
	# Calculate and print the total number of purchases
	puts "Total Purchases: #{product["purchases"].length}"
	# Calculate and print the total amount of sales
	while i < product["purchases"].length
		product["purchases"].each do |sale|
			amount_sales.push(sale["price"])
			i += 1
		end
	end
	total_sales = amount_sales.reduce(:+)
	puts "Total Sales: $#{total_sales}"
	# Calculate and print the average price the toy sold for
	avg_price = total_sales / product["purchases"].length
	puts "Average Price: $#{avg_price}"
	# Calculate and print the average discount ($) based off the average sales price
	avg_discount = (total_retail - total_sales) / product["purchases"].length
	puts "Average Discount: $#{avg_discount}"
	# Calculate and print the average discount (%) based off the average sales price
	avg_discountPercent = (total_retail - total_sales) / total_retail * 100
	puts "Average Discount Percentage: #{avg_discountPercent.round(2)}%"
	puts "\n"
end

# Print "Brands" in ascii art
puts " _                         _     "
puts "| |                       | |    "
puts "| |__  _ __ __ _ _ __   __| |___ "
puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
puts "| |_) | | | (_| | | | | (_| \\__ \\"
puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
puts

# For each brand in the data set:
# Gets rid of any duplicates
brand = products_hash["items"].map {|brand_name| brand_name["brand"]}.uniq
# Variables for the loops below
lego_stock = nano_stock = lego_price = nano_price = lego_count = nano_count = lego_total = nano_total = i = 0



products_hash["items"].each do |stock|
	#Checks if the brand name is LEGO
	if stock["brand"] == "LEGO"
		# Counts the number of toys that are in stock for the LEGO brand
		lego_stock += stock["stock"]
		# Changes stock["full-price"] from a string to a float
		price = stock["full-price"].to_f
		lego_price += price
		# Keeps track of how many brands are Nano Blocks
		lego_count += 1
		# Adds each brand purchases["price"] together for total sales
		stock["purchases"].each{|price| lego_total += price["price"]}
		#Checks if the brand name is Nano Blocks
	elsif stock["brand"] == "Nano Blocks"
		# Counts the number of toys that are in stock for the Nano Blocks brand
		nano_stock += stock["stock"]
		# Changes stock["full-price"] from a string to a float
		price = stock["full-price"].to_f
		nano_price += price
		# Keeps track of how many brands are Nano Blocks
		nano_count += 1
		# Adds each brand purchases["price"] together for total sales
		stock["purchases"].each{|price| nano_total += price["price"]}
	end
end

while i < brand.length
	if brand[i] == "LEGO"
		# Print the name of the brand
		puts brand[i] + "\n********************"
		puts "Number of Products: #{lego_stock}"
		# Calculate and print the average price of the brand's toys
		average_price = lego_price / lego_count
		puts "Average Product Price: $#{average_price.round(2)}"
		# Calculate and print the total revenue of all the brand's toy sales combined
		puts "Total Sales: $#{lego_total.round(2)}"
		puts "\n"
	elsif brand[i] =="Nano Blocks"
		# Print the name of the brand
		puts brand[i] + "\n********************"
		puts "Number of Products: #{nano_stock}"
		# Calculate and print the average price of the brand's toys
		average_price = nano_price / nano_count
		puts "Average Product Price: $#{average_price.round(2)}"
		# Calculate and print the total revenue of all the brand's toy sales combined
		puts "Total Sales: $#{nano_total.round(2)}"
	end
	i += 1
end

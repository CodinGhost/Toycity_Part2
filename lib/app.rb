require 'date'
require 'artii'
require 'json'

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/artii.rb')
	file = File.read(path)
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file) # Global variable
	$report_file = File.new("../report.txt", "w+") # Create a new text file, w+ lets you read and write to the file.
end

def print_report(text)
	File.open($report_file, 'a') {|file| file.puts(text)}
end
# Brings all the product and brand data & adds it to the sales report
def create_report
	title_report("Sales Report")
	print_report "********************"
	# Displays the time when the salee report was generated.
	time_date
	print_report "********************"
	# Prints all the products data to the sales report
	print_products
	# Prints all the brand data to the the sales report
	print_brands
end

def title_report(name)
	# Creats all the ASCII art for the headers
	header_artii = Artii::Base.new
	print_report header_artii.asciify(name)
end

def time_date
	# Stores the current time
	current_time = DateTime.now.strftime('%m/%d/%y')
	print_report "Report Generated On: #{current_time} \n"
end

def print_products
	title_report("Products")
	product_base_method
end

def print_brands
	title_report("Brands")
	brand_base_method
end

def product_base_method
	$products_hash["items"].each do |items|
		product_data(items)
		print_report "********************"
		print_report " "
	end
end
# Holds all of the products data
def product_data(items)
	# The product's name
	products_name(items)
	# The product's retail pricing
	products_retail_price(items)
	# The amount of that specific product sold
	products_sold(items)
	# The product's total amount of sales
	products_total_sales(items)
	# The product's average price
	products_sold_avg(items)
	# The amount of discount the product was sold for
	products_discount(items)
end

# Prints the product's name
def products_name(items)
	print_report "Item Name: #{items["title"]}"
	print_report "********************"
end

# Prints to sales report the retail price of the product
def products_retail_price(items)
	print_report "Retail Price: $#{items["full-price"]}"
end

# Calculates and prints to sales report, the amount of products sold
def products_sold(items)
	$total_purchased = items["purchases"].length
	print_report "Total Purchases: #{$total_purchased}"
end

# Calculates and print to sales report, the total amount products were sold for
def products_total_sales(items)
	$total_sales = 0
	items["purchases"].each do |price|
		$total_sales += price["price"]
	end
	print_report "Total Amount of Sales: $#{$total_sales}"
end

# Calculates and prints to report, the average price each product was sold for
def products_sold_avg(items)
	$average_price = $total_sales/$total_purchased
	print_report "Average Price: $#{$average_price}"
end

# Calculates and print to report, the average discount of each product
def products_discount(items)
	total_retail = items["full-price"].to_f * items["purchases"].length
	product_discount = Float(items["full-price"]) - $average_price
	print_report "Average Discount: $#{product_discount}"
	percent_discount = (total_retail - $total_sales) / total_retail * 100
	print_report "Average Discount Percentage:: #{percent_discount.round(2)}%"
end

# Holds and stores all the variables for the brand section
def brand_base_method
	brands = $products_hash["items"].map {|name| name["brand"]}.uniq
	brands.each do |brand|
		$by_brand = $products_hash["items"].select {|item| item["brand"] == brand}
		$total_stock = 0
		$total_price = 0
		$total_revenue = 0
		$brand_amount = $by_brand.length
		brand_names(brand)
		brand_data(brand)
		print_report "********************"
		print_report " "
	end
end

# Prints brand's name
def brand_names(brand)
	print_report "#{brand}"
	print_report "********************"
end

# Holds all the brand's data
def brand_data(brand)
	$by_brand.each do |item|
		brand_stock(item)
		brand_price(item)
		brand_revenue(item)
	end
	print_report "Number of Products: #{$total_stock}"
	print_report "Average Products Price: $#{($total_price/$brand_amount).round(2)}"
	print_report "Total Revenue: $#{$total_revenue.round(2)}"
end

# Calculates and displays the brands total stock
def brand_stock(item)
	$total_stock += item["stock"]
end

# Calculates and displays the brands total products total price
def brand_price(item)
	$total_price += item["full-price"].to_f
end

# Calculates and displays the total revenue of all the brand's products.
def brand_revenue(item)
	item["purchases"].each do |price|
		$total_revenue += price["price"]
	end
end

def start
	setup_files
	create_report
end

start

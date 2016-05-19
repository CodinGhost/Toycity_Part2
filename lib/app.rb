require 'date'
require 'artii'
require 'json'

path = File.join(File.dirname(__FILE__), '../data/artii.rb')
file = File.read(path)

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file) # Global variable
	$report_file = File.new("../report.txt", "w+") # Create a new text file, w+ lets you read and write to the file.
end

# Methods
def print_report(text)
	File.open($report_file, 'a') {|file| file.puts(text)}
end

def create_report
	title_report("Sales Report")
	time_date
	print_products
	print_brands
end

def title_report(name)
	header_artii = Artii::Base.new
	print_report header_artii.asciify(name)
end

def time_date
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

def product_data(items)
	$total_retail = items["full-price"].to_f * items["purchases"].length
	products_name(items)
	products_retail_price(items)
	products_sold(items)
	products_total_sales(items)
	products_sold_avg(items)
	products_discount(items)
end

def products_name(items)
	print_report "Item Name: #{items["title"]}"
	print_report "********************"
end

def products_retail_price(items)
	print_report "Item Retail Price: $#{items["full-price"]}"
end

def products_sold(items)
	$total_purchased = items["purchases"].length
	print_report "Total Sold: #{$total_purchased}"
end

def products_total_sales(items)
	$total_sales = 0
	items["purchases"].each do |price|
		$total_sales += price["price"]
	end
	product_discount = ($total_retail - $total_sales) / $total_sales * 100
	print_report "Total amount of sales: $#{$total_sales}"
	print_report "#{product_discount}"
end

def products_sold_avg(items)
	$average_price = $total_sales/$total_purchased
	print_report "Average Price: $#{$average_price}"
end

def products_discount(items)
	discount = Float(items["full-price"]) - $average_price
	print_report "Average Discount: $#{discount}"
end

def start
	setup_files
	create_report
end

start

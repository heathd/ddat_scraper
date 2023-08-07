require 'zeitwerk'
loader = Zeitwerk::Loader.new
# loader.push_dir(File.dirname(__FILE__) + "/lib")
loader.setup

require 'mechanize'
require 'pry'

agent = Mechanize.new
page = agent.get("https://www.gov.uk/guidance/software-developer")

content = page.css('#contents .govspeak')

# split up the page into chunks starting with an H2
content.children.slice_before {|c| c.name =='h2' }


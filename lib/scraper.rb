require 'mechanize'
require 'reverse_markdown'
require 'pry'

class Scraper
	attr_reader :url, :agent

	def initialize(url)
		@agent = Mechanize.new
		@url = url
	end

	def page
		@page ||= agent.get(url)
	end

	def content
		@content ||= page.css('#contents .govspeak')
	end

	def chunks
		@chunks ||= content.children.slice_before {|c| c.name =='h2' }.to_a[2..-2].map {|c| Chunk.new(c)}
	end

	def headings
		chunks.map do |c|
			c.title
		end
	end

	class Chunk
		attr_reader :child_elements, :preamble_elems, :skills_elems
		
		def initialize(child_elements)
			@child_elements = child_elements
			@preamble_elems, @skills_elems = child_elements.slice_before {|n| n.name == 'h3' && n.text =~ /Skills needed/}.to_a
		end

		def title
			child_elements.first.text
		end

		def preamble
			ReverseMarkdown.convert(preamble_elems[2..-1].map {|e| e.to_html}.join(""))
		end

		def skills
			skills_elems[2..-1].first.css("li").map do |li|
				li.text.strip =~ /^([^\.]+?)\. ?(.*?) ?\(Skill level: ([^\)]+)\)$/
				{
					skill: $1,
					description: $2,
					required_level: $3
				}
			end
		end
	end
end
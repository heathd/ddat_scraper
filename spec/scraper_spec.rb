require 'mechanize'
require 'pathname'

RSpec.describe Scraper do
	let(:spec_path) { Pathname.new(File.dirname(__FILE__)) + "fixtures" }
	let(:url) { "file://" + (spec_path + "software-developer.html").to_s }
	subject(:scraper) { Scraper.new(url) }
	let(:first_chunk) { scraper.chunks.first }
	
	it "finds the headings" do
		expect(scraper.headings).to eq(
			[
				"Apprentice developer",
				"Junior developer",
				"Developer",
				"Senior developer",
				"Senior developer - management",
				"Lead developer",
				"Lead developer - management",
				"Principal developer",
				"Principal developer - management",
			]
		)
	end

	it "finds the preamble of the first chunk" do
		expect(first_chunk.preamble).to eq(<<HERE
An apprentice developer attends certified training and develops skills on the job.

At this role level, you will:

- spend a substantial portion of time shadowing others
- work with other developers to write code and tests
- build your knowledge
- follow a test-driven approach
- write code that is automatically tested
HERE
			)
	end

	it "finds the skills of the first chunk" do
		expect(first_chunk.skills).to eq(
			[
				{
					skill: "Availability and capacity management",
					description: "You can show an awareness of availability and capacity management processes.",
					required_level: "awareness"
				},
				{
					skill: "Information security",
					description: "You can discuss information security and the security controls that can be used to mitigate security threats within solutions and services.",
					required_level: "awareness"
				},
				{
					skill: "Modern standards approach",
					description: "You can understand the importance of adopting a modern standards approach.",
					required_level: "awareness"
				},
				{
					skill: "Programming and build (software engineering)",
					description: "You can design, code, test, correct and document simple programs or scripts under the direction of others.",
					required_level: "working"
				},
				{
					skill: "Prototyping",
					description: "You can explain what prototyping is, and why and when to use it. You can understand how to work in an open and collaborative environment (by pair working, for example).",
					required_level: "awareness"
				},
				{
					skill: "Service support",
					description: "You can help with the investigation and resolution of infrastructure problems, undertaking specific activities under direction.",
					required_level: "awareness"
				},
				{
					skill: "User focus",
					description: "You can show an awareness or understanding of user experience analysis and its principles. You can explain the purpose of user stories and the focus on user needs.",
					required_level: "awareness"
				}
			]
		)
	end
end
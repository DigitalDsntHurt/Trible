require 'csv'
require 'open-uri'

=begin
=end
#
## download bible as text file from project gutenberg
#
bible_file = open( "http://www.gutenberg.org/files/30/30.txt" )
destination_file = File.join(File.dirname(__FILE__), 'bible.txt')
IO.copy_stream( bible_file, destination_file )

=begin
=end
#
## create two-column csv
## col1: book:chapter:verse, col2: verse text
#

raw_lines = []
File.open(destination_file).each_line{ |line|
	raw_lines << line
}

temp_verses = []
raw_lines.each_with_index{|line,i|
	if line[0..9].count(":") == 2
		temp_verses << [ i, line[0..9], line[11..-1] ]
	end
}

use_verses = []
temp_verses.each{|temp_verse|
	@tmp_verse = []
	@current_index = temp_verse[0]
		until raw_lines[@current_index] == "\r\n"
			@tmp_verse << raw_lines[@current_index]
			@current_index += 1
			break if raw_lines[@current_index] == nil
		end 

	@use_verse = []
	@mapped_tmp_verse = @tmp_verse.map{ |v| v.gsub("\r\n"," ").gsub("           ","") }
	@use_verse << @mapped_tmp_verse[0][0..9]
	@use_verse << @mapped_tmp_verse[0][11..-1] + @mapped_tmp_verse[1..-1].join.strip
	use_verses << @use_verse
}

CSV.open( File.join( File.dirname(__FILE__),'bible_verses.csv' ) ,"w+" ) do |f|
	use_verses.each{|v|
		f << v
		#p v 
	}
end




=begin
#
## create two-column csv
## col1: book:verse:line, col2: line text
#
raw_lines = []
File.open(destination_file).each_line{ |line|
	raw_lines << line
}

temp_verses = []
raw_lines.each_with_index{|line,i|
	if line[0..9].count(":") == 2
		temp_verses << [ i, line[0..9], line[11..-1] ]
	end
}

use_lines = []
temp_verses.each{|temp_verse|
	@tmp_verse = []
	@current_index = temp_verse[0]
		until raw_lines[@current_index] == "\r\n"
			@tmp_verse << raw_lines[@current_index]
			@current_index += 1
			break if raw_lines[@current_index] == nil
		end 

	@use_line = []
	@mapped_tmp_verse = @tmp_verse.map{ |v| v.gsub("\r\n"," ").gsub("           ","") }	
	@verse_meta = @mapped_tmp_verse[0][0..9]

	@use_line << @verse_meta
	@use_line << @mapped_tmp_verse[0][11..-1]
	use_lines << @use_line

	@mapped_tmp_verse[1..-1].each{|line|
		@use_line = []
		@use_line << @verse_meta
		@use_line << line
		use_lines << @use_line
	}
	use_lines << [nil,nil,nil]
}

CSV.open("/Users/Graphiq-NS/Desktop/TrumpBible--TwitterBot/bible_lines.csv","w+") do |f|
	use_lines.each{|v|
		f << v
		p v 
	}
end
=end
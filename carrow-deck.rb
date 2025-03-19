
require 'discordrb'
require 'yaml'
require 'dicebag'
require 'chunky_png'
bot =  Discordrb::Commands::CommandBot.new token: '', prefix: '!'
puts "My invite URL is #{bot.invite_url}"



if "Tarot".to_i == 0

CUPS = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]
PENTACLES = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]
SWORDS = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]
WANDS = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]

MAJOR_ARCANA = [
  "The Fool",
  "The Magician",
  "The High Priestess",
  "The Empress",
  "The Emperor",
  "The Hierophant",
  "The Lovers",
  "The Chariot",
  "Strength",
  "The Hermit",
  "Wheel of Fortune",
  "Justice",
  "The Hanged Man",
  "Death",
  "Temperance",
  "The Devil",
  "The Tower",
  "The Star",
  "The Moon",
  "The Sun",
  "Judgment",
  "The World"
]



bot.command :tarot do |event|
  if rand(2) == 0
    card = MAJOR_ARCANA.sample
  else
    suit = [CUPS, PENTACLES, SWORDS, WANDS].sample
    card = suit.sample
  end
  event.respond "You drew the **#{card}** card!"
end


end



class Font
  attr_accessor :font_space, :character_spacing

  def initialize(font_space, character_spacing)
    @font_space = font_space
    @character_spacing = character_spacing
  end

  def render_text(canvas,text, x, y,resizeamt,altnumber=false)
folder_path1 = $save_directory + "/Data/Grid Assets/"
    text.chars.each_with_index do |char, index|
	  if is_capital_letter?(char)
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/capital/' + char +'.png' ))
	  elsif is_number?(char)
	  if altnumber==false
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/numbers/' + char +'.png' ))
	  else
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/smallnumbers/' + char +'.png' ))
	  end
	  else
	  
    if char == "/"
	 char = "frontslash"
	end
    if char == "\\"
	 char = "backslash"
	end
	if char == ":"
	 char = "colon"
	end
	if char == " "
	 char = "space"
	end
	if char == "!"
	 char = "exclaim"
	end
	if char == "'"
	 char = "apos"
	end
	if char == "."
	 char = "period"
	end


	  if altnumber==false
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/lowercase/' + char +'.png' ))
	  else
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/smallnumbers/' + char +'.png' ))
	  end
	  end
	  character = character.resize(character.width*resizeamt, character.height*resizeamt)
      canvas.compose!(character, x + index * (@font_space + @character_spacing), y)
    end

	  return canvas
  end
  
  
  def render_text_color(canvas,text, x, y,resizeamt,color,altnumber=false)
folder_path1 = $save_directory + "/Data/Grid Assets/"
new_red = 0
new_green = 0
new_blue = 0
if color == "Red"
new_red = 255
new_green = 0
new_blue = 0
end
    text.chars.each_with_index do |char, index|
	  if is_capital_letter?(char)
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/capital/' + char +'.png' ))
	  elsif is_number?(char)
	  if altnumber==false
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/numbers/' + char +'.png' ))
	  else
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/smallnumbers/' + char +'.png' ))
	  end
	  else
	  
    if char == "/"
	 char = "frontslash"
	end
    if char == "\\"
	 char = "backslash"
	end
	if char == ":"
	 char = "colon"
	end
	if char == " "
	 char = "space"
	end
	if char == "!"
	 char = "exclaim"
	end
	  if altnumber==false
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/lowercase/' + char +'.png' ))
	  else
      character = ChunkyPNG::Image.from_file(File.join(folder_path1 + 'font/smallnumbers/' + char +'.png' ))
	  end
	  end
	  character = character.resize(character.width*resizeamt, character.height*resizeamt)
	  character.height.times do |y|
          character.width.times do |x|
              pixel = character[x, y]
              next if ChunkyPNG::Color.a(pixel) == 0
               pixel = character[x, y]
              alpha = ChunkyPNG::Color.a(pixel)
              character[x, y] = ChunkyPNG::Color.rgba(new_red, new_green, new_blue, alpha)
          end
      end

      canvas.compose!(character, x + index * (@font_space + @character_spacing), y)
    end

	  return canvas
  end
  
  def is_capital_letter?(char)
    if char == char.upcase && char != char.downcase
     return true
	else
     return false
	end
  end
  def is_number?(char)
   if char.match?(/\d/)
     return true
   else
     return false
   end
  end
end




bot.ready do
  bot.game = 'Neverlands'
end

bot.run
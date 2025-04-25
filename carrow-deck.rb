
require 'discordrb'
require 'yaml'
require 'dicebag'
require 'chunky_png'
bot =  Discordrb::Commands::CommandBot.new token: '', prefix: '!'
puts "My invite URL is #{bot.invite_url}"



if "Tarot".to_i == 0
 
 SUITS =  ["Cups", "Swords", "Wands", "Pentacles"]
 RANKS = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Acolyte", "Knight", "Maid", "Witch"]

MAJOR_ARCANA = [
  "The Wayfarer",
  "The Miracle-Worker",
  "The Tides",
  "Abundance",
  "The Ancestor",
  "The Weaver",
  "The Scientist",
  "The Coven",
  "The Ruler",
  "The General",
  "Fortune",
  "The Scales",
  "The Collective",
  "Rebirth",
  "The Bear",
  "The Sacrifice",
  "The Tome",
  "Hope",
  "The Unknown",
  "The Hearth",
  "The Wilderness",
  "The Home"
]

def get_tarot(type)
    suits = SUITS.dup 
    ranks = RANKS.dup 

	 if type == "extended"
	  suits << "Shields"
      type = "full"
	 end
 
 return ranks,suits,type
end

def generate_tarot(card)
  path = File.dirname(__FILE__) + "/Graphics/cards/"
  images = []
 if !File.exist?(path)
   return nil
 end
 if File.exist?(path + card + ".png")
  return File.open(path + card + ".png", 'r')
 end
 base = path + "/base/tarot.png"
 if !File.exist?(base)
   return nil
 end
  base = ChunkyPNG::Image.from_file(base)
  font = Font.new("newrocker",16, 16)
  width = base.width
  height = base.height
  image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
  image.compose!(base, 0, 0)
  image = font.render_text(image, card, 4, 10, 1.5, "#FFFFFF")
  image = image.resize((width/2).to_i, (height/2).to_i)
  image.save(path + card + ".png")
  #oranges = (File.new(path + card))
 return File.open(path + card + ".png", 'r')
end


bot.command :draw do |event, amt = 1, type = "full"|
  amt = amt.to_i if amt.is_a? String
  cards = []
  images = []
  ranks,suits,type = get_tarot(type)
  amt.times do |i|
   case type.downcase
   when "full"
    if rand(2) == 0 
	 loop do 
      card = MAJOR_ARCANA.sample
       puts card
	  if !cards.include?(card)
	  cards << card
	  break
	  end
	 end
    else
	 loop do 
      suit = suits.sample
      rank = ranks.sample
	  card = "#{rank} of #{suit}"
       puts card
	  if !cards.include?(card)
	  cards << card
	  break
	  end
	 end
    end
   when "major"
	 loop do 
    card = MAJOR_ARCANA.sample
       puts card
	  if !cards.include?(card)
	  cards << card
	  break
	  end
	 end
   when "minor"
   
	 loop do 
    suit = suits.sample
    rank = ranks.sample
	card = "#{rank} of #{suit}"
       puts card
	  if !cards.include?(card)
	  cards << card
	  break
	  end
	end
   end
  end
  
  if cards.length>1
    result = ""
	cards.each_with_index do |card, index|
	 result += "**#{card}"
	 result += "**, " if index<cards.length-1
	 result += "**" if index==cards.length-1
	end
  else
   result =  "the **#{cards[0]}**"
  end
	cards.each_with_index do |card, index|
      file = generate_tarot(card)
	  if file.nil?
       event.respond("An unexpected error has occured.")
	   return nil
	  end
      event.send_file(file, caption: "You draw **#{card}**.") 
	  images << file
    end
  event.respond("You draw #{result}.") if images.empty?
   return nil
end



bot.command :tarot do |event, amt = 1, type = "full"|
  amt = amt.to_i if amt.is_a? String
  cards = []
  ranks,suits = get_tarot(type)
  amt.times do |i|
   case type
   when "full"
    if rand(2) == 0 
      card = MAJOR_ARCANA.sample
	  cards << card
    else
      suit = suits.sample
      rank = ranks.sample
	  card = "#{rank} of #{suit}"
	  cards << card
    end
   when "major"
    card = MAJOR_ARCANA.sample
	cards << card
   when "minor"
    suit = suits.sample
    rank = ranks.sample
	card = "#{rank} of #{suit}"
	cards << card
   end
  end
  
  if cards.length>1
    result = ""
	cards.each_with_index do |card, index|
	 result += "**#{card}"
	 result += "**, " if index<cards.length-1
	 result += "**" if index==cards.length-1
	end
  else
   result =  "the **#{cards[0]}**"
  end

  event.respond("You draw #{result}.") if result
end

end


class Tarot





end

class Font
  attr_accessor :font_space, :character_spacing, :font_name

  def initialize(font_name, font_space, character_spacing)
    @font_space = font_space
    @character_spacing = character_spacing
	@path = File.dirname(__FILE__) + "/Graphics/fonts/"
	@font_name = font_name
  end

  def render_text(bitmap, text, x, y, size = 1, color=nil)
    text.chars.each_with_index do |chara, index|
	  chara = convert_special_character(chara)
	  if is_capital_letter?(chara)
      character = ChunkyPNG::Image.from_file(File.join(@path + @font_name + '/capital/' + chara +'.png' ))
	  elsif is_lowercase_letter?(chara)
      character = ChunkyPNG::Image.from_file(File.join(@path + @font_name + '/lowercase/' + chara +'.png' ))
	  elsif is_number?(chara)
      character = ChunkyPNG::Image.from_file(File.join(@path + @font_name + '/numbers/' + chara +'.png' ))
	  else
      character = ChunkyPNG::Image.from_file(File.join(@path + @font_name + '/special/' + chara +'.png' ))
	  end
	  character = character.resize((character.width * size).to_i, (character.height * size).to_i)

    if @font_name == "newrocker"
      #centered_character = ChunkyPNG::Image.new(102, 102, ChunkyPNG::Color::TRANSPARENT)
      #offset_x = (102/2 - character.width) / 2
      #offset_y = (102/2 - character.height) / 2
      #centered_character = centered_character.resize((centered_character.width * 0.5).to_i, (centered_character.height * 0.5).to_i)
      threshold = 60  # You can adjust this to control how much "white" is replaced

      character.height.times do |y|
        character.width.times do |x|
          pixel = character[x, y]
          r = ChunkyPNG::Color.r(pixel)
          g = ChunkyPNG::Color.g(pixel)
          b = ChunkyPNG::Color.b(pixel)

          # Check if the pixel is close to white (within a threshold)
          if r > threshold && g > threshold && b > threshold
            character[x, y] = ChunkyPNG::Color::TRANSPARENT
          end
        end
      end

      #centered_character.compose!(character, offset_x, offset_y)
      #character = centered_character
    end


	  if !color.nil?
	  character.height.times do |y|
          character.width.times do |x|
              pixel = character[x, y]
              next if ChunkyPNG::Color.a(pixel) == 0
               pixel = character[x, y]
              alpha = ChunkyPNG::Color.a(pixel)
              character[x, y] = ChunkyPNG::Color.from_hex(color)
          end
      end
	  end
      bitmap.compose!(character, x + index * ((@font_space * size) + @character_spacing) , y)
    end
    return bitmap
  end
  
  def convert_special_character(chara)
  
    if chara == "/"
	 chara = "frontslash"
	end
    if chara == "\\"
	 chara = "backslash"
	end
	if chara == ":"
	 chara = "colon"
	end
	if chara == " "
	 chara = "space"
	end
	if chara == "!"
	 chara = "exclaim"
	end
	if chara == "'"
	 chara = "apos"
	end
	if chara == "."
	 chara = "period"
	end
	if chara == "("
	 chara = "parenleft"
	end
	if chara == ")"
	 chara = "parenright"
	end
	if chara == "-"
	 chara = "dash"
	end
  
  
  
   return chara
  end
 
  def is_capital_letter?(chara)
    if chara == chara.upcase && chara != chara.downcase && chara.chars.length==1
     return true
	else
     return false
	end
  end
 
  def is_lowercase_letter?(chara)
    if chara != chara.upcase && chara == chara.downcase && chara.chars.length==1
     return true
	else
     return false
	end
  end

  def is_number?(chara)
   if chara.match?(/\d/) && chara.chars.length==1
     return true
   else
     return false
   end
  end

def is_special_character?(chara)
  if chara.match?(/[^a-zA-Z0-9]/)
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
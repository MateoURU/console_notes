require 'json'

class Note
  notesFile = File.read('./notes_db.json')
    @notes = JSON.parse(notesFile)
  archiveFile = File.read('./archive_db.json')
    @archive = JSON.parse(archiveFile)

  START_OPTIONS = ["1 => List notes", "2 => Go to specific note", "3 => Show archived notes", "4 => New note"]
  OPTIONS = ["1 => Edit", "2 => Send to Archive", "3 => Delete", "4 => Close Notes App", "5 => New note"]

  def self.getPosition(id)
    @notes.each_with_index { |note, ind| return ind if note["id"] == id }
  end

  def self.start
    puts "Choose one of the following actions: "
    START_OPTIONS.each { |opt | puts opt}
    selected = gets.chomp.to_i
    case selected
    when 1
      list(@notes)
      open
    when 2
      open
    when 3
      list(@archive)
    when 4
      newNote
    else
      puts "na, le erraste"
    end
  end

  def self.options
    OPTIONS.each { |opt | puts opt}
    selected = gets.chomp.to_i
    case selected
    when 1
      editNote(@selectedNote)
    when 2
      archiveNote(@selectedNote)
    when 3
      deleteNote(@selectedNote)
    when 4
      puts "> > > Closing App < < <"
    when 5
      newNote
    else
      puts "na, le erraste"
    end
  end

  def self.list(list)
    puts  "--------------------------------------------"
    list.each do |note|
      puts "#{note["id"]} => #{note["title"]}"
    end
    puts  "--------------------------------------------"
  end

  def self.open
    puts "Select one note id: "
    @selectedNote = getPosition(gets.chomp.to_i)
    puts "//////////////////////////////////////////////"
    puts ""
    puts @notes[@selectedNote]["title"]
    puts "   #{@notes[@selectedNote]["description"]}"
    puts ""
    puts "//////////////////////////////////////////////"
    options
  end

  def self.newNote
    newId = @notes.map { |n| n["id"] }.max + 1
    puts "---------NEW NOTE-------------"
    puts "Title: "
    title = gets.chomp
    puts "Description: "
    description = gets.chomp
    puts "------------------------------"
    puts ""
    newNote = { "id" => newId,"title" => title, "description" => description }
    puts newNote
    @notes.append(newNote)
    File.write('./notes_db.json',JSON.dump(@notes))
  end

  def self.editNote(position)
    puts " >>> Note title: #{@notes[position]["title"]}"
    puts " >>> Note description: #{@notes[position]["description"]}"
    puts "New title: (enter to omit)"
    newTitle = gets.chomp
    puts "New description: (enter to omit)"
    newDescription = gets.chomp
    @notes[position]["title"] = newTitle unless newTitle.empty?
    @notes[position]["description"] = newDescription unless newDescription.empty?

    puts '///////////////////////////////////////'
    puts "Updated note: "
    puts @notes[position]["title"]
    puts "   #{@notes[position]["description"]}"
    puts '///////////////////////////////////////'
    File.write('./notes_db.json',JSON.dump(@notes))
  end

  def self.deleteNote(position)
    puts " >>> The following note: #{@notes[position]["title"]} was deleted <<<"
    @notes.delete_at(position)
    File.write('./notes_db.json',JSON.dump(@notes))
  end

  def self.archiveNote(position)
    puts " >>> The following note: #{@notes[position]["title"]} was sent to Archive <<<"
    @archive.append(@notes[position])
    @notes.delete_at(position)
    File.write('./archive_db.json',JSON.dump(@archive))
    File.write('./notes_db.json',JSON.dump(@notes))
  end

end

Note.start
